namespace :interventions do
    
    desc "Relancer par email"
    task :relancer, [:enregistrer] => :environment do |task, args|
        interventions = Intervention.with_terminé_state.where("updated_at::DATE - NOW()::DATE = ?", 3)

        interventions.each do |intervention|
            if intervention.adherent
                mailer_response = NotificationMailer.relance(intervention).deliver_now
                MailLog.create(organisation_id: intervention.organisation_id, user_id: 0, message_id: mailer_response.message_id, to: intervention.adherent.email, subject: "Relance : intervention terminée")
                intervention.update!(audit_comment: "Adhérent relancé par mail pour la validation de l'intervention")
                # puts "-- Traitement terminé --"
                # puts "'#{intervention.description}' traitée"
            end
        end

    end

end