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

    // Segmented GHR: [6:4] recent, [3:0] older
    reg [6:0] ghr;
    
    // Confidence-enhanced PHT (2-bit counter + 1-bit confidence)
    reg [2:0] pht_recent [0:127];  // For recent history segment
    reg [2:0] pht_older [0:127];   // For older history segment
    
    // Misprediction recovery buffer
    reg [6:0] recovery_history;
    reg recovery_valid;
    
    // Prediction indices
    wire [6:0] index_recent = predict_pc ^ {ghr[6:4], 4'b0};
    wire [6:0] index_older = predict_pc ^ {4'b0, ghr[3:0]};
    
    // Prediction values
    wire recent_taken = pht_recent[index_recent][1];
    wire older_taken = pht_older[index_older][1];
    wire recent_conf = pht_recent[index_recent][2];
    wire older_conf = pht_older[index_older][2];
    
    // Weighted prediction (confidence-weighted voting)
    assign predict_taken = predict_valid ? 
                         ((recent_conf && older_conf) ? (recent_taken & older_taken) :
                          recent_conf ? recent_taken :
                          older_conf ? older_taken :
                          (recent_taken | older_taken)) : 1'b0;
    assign predict_history = ghr;
    
    // Training indices
    wire [6:0] train_index_recent = train_pc ^ {train_history[6:4], 4'b0};
    wire [6:0] train_index_older = train_pc ^ {4'b0, train_history[3:0]};
    
    // Adaptive update strength
    wire strong_update_recent = pht_recent[train_index_recent][2];
    wire strong_update_older = pht_older[train_index_older][2];
    
    // PHT update logic with adaptive strength
    function [2:0] update_counter;
        input [2:0] current;
        input taken;
        input strong;
    begin
        if (strong) begin
            // Strong update (bigger step)
            update_counter = taken ? 
                            (current[1:0] == 2'b11 ? {1'b1, 2'b11} : {1'b1, current[1:0] + 1}) :
                            (current[1:0] == 2'b00 ? {1'b0, 2'b00} : {1'b0, current[1:0] - 1});
        end else begin
            // Weak update (normal step)
            update_counter = taken ? 
                            (current[1:0] == 2'b11 ? current : {current[2], current[1:0] + 1}) :
                            (current[1:0] == 2'b00 ? current : {current[2], current[1:0] - 1});
        end
    end
    endfunction
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            recovery_valid <= 1'b0;
            for (integer i = 0; i < 128; i = i + 1) begin
                pht_recent[i] <= 3'b010;  // Weakly not-taken, low confidence
                pht_older[i] <= 3'b010;
            end
        end else begin
            // Handle training first (higher priority)
            if (train_valid) begin
                // Update both PHTs
                pht_recent[train_index_recent] <= 
                    update_counter(pht_recent[train_index_recent], train_taken, strong_update_recent);
                pht_older[train_index_older] <= 
                    update_counter(pht_older[train_index_older], train_taken, strong_update_older);
                
                // Store recovery history if mispredicted
                if (train_mispredicted) begin
                    recovery_history <= {train_history[5:0], train_taken};
                    recovery_valid <= 1'b1;
                end
            end
            
            // Update GHR - recovery has highest priority
            if (recovery_valid) begin
                ghr <= recovery_history;
                recovery_valid <= 1'b0;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule