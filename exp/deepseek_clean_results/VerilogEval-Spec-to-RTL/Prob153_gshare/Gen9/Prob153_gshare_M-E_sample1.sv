module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Shadow PHT implementation
    reg [1:0] pht_pred [0:127];  // Prediction PHT (front-end)
    reg [1:0] pht_train [0:127]; // Training PHT (back-end)
    
    // Global History Register with shadow buffer
    reg [6:0] ghr;
    reg [6:0] ghr_shadow;
    reg [6:0] ghr_committed;
    
    // Misprediction recovery queue
    reg [6:0] recovery_history;
    reg recovery_valid;
    
    // PHT update queue
    reg [6:0] update_index;
    reg [1:0] update_value;
    reg update_valid;
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht_pred[predict_index][1];
    assign predict_history = ghr;
    
    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] current_train_value = pht_train[train_index];
    
    // Saturating counter update function
    function [1:0] update_counter;
        input [1:0] current;
        input taken;
        begin
            case ({current, taken})
                3'b000: update_counter = 2'b00;
                3'b001: update_counter = 2'b01;
                3'b010: update_counter = 2'b01;
                3'b011: update_counter = 2'b10;
                3'b100: update_counter = 2'b01;
                3'b101: update_counter = 2'b10;
                3'b110: update_counter = 2'b11;
                3'b111: update_counter = 2'b11;
            endcase
        end
    endfunction
    
    // Main operational logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize both PHTs to weakly taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht_pred[i] <= 2'b01;
                pht_train[i] <= 2'b01;
            end
            
            ghr <= 7'b0;
            ghr_shadow <= 7'b0;
            ghr_committed <= 7'b0;
            recovery_valid <= 1'b0;
            update_valid <= 1'b0;
        end else begin
            // Handle misprediction recovery first
            if (recovery_valid) begin
                ghr <= recovery_history;
                ghr_shadow <= recovery_history;
                recovery_valid <= 1'b0;
            end
            
            // Process PHT updates from training
            if (update_valid) begin
                pht_pred[update_index] <= update_value;
                update_valid <= 1'b0;
            end
            
            // Handle training updates
            if (train_valid) begin
                // Update training PHT immediately
                pht_train[train_index] <= update_counter(current_train_value, train_taken);
                
                // Queue update for prediction PHT
                update_index <= train_index;
                update_value <= update_counter(current_train_value, train_taken);
                update_valid <= 1'b1;
                
                // Handle misprediction recovery
                if (train_mispredicted) begin
                    recovery_history <= {train_history[5:0], train_taken};
                    recovery_valid <= 1'b1;
                end
            end
            
            // Update speculative history for predictions
            if (predict_valid && !recovery_valid) begin
                ghr <= {ghr[5:0], predict_taken};
                ghr_shadow <= {ghr_shadow[5:0], predict_taken};
            end
            
            // Synchronize committed history
            ghr_committed <= ghr;
        end
    end
    
    // Shadow PHT synchronization (optional optimization)
    always @(posedge clk) begin
        if (train_valid && !train_mispredicted) begin
            pht_train[train_index] <= update_counter(current_train_value, train_taken);
        end
    end

endmodule