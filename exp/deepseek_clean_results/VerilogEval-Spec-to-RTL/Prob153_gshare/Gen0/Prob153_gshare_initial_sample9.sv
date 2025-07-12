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

    // Pattern History Table (128 entries of 2-bit counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];  // MSB determines prediction
    assign predict_history = ghr;
    
    // Training logic
    wire [6:0] train_index = train_pc ^ train_history;
    reg [6:0] next_ghr;
    reg update_ghr;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset all PHT entries to weakly not taken (01)
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT for training
            if (train_valid) begin
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            // Update GHR
            if (update_ghr) begin
                ghr <= next_ghr;
            end
        end
    end
    
    // GHR update logic
    always @(*) begin
        update_ghr = 1'b0;
        next_ghr = ghr;
        
        // Training has priority over prediction
        if (train_valid) begin
            if (train_mispredicted) begin
                // On misprediction, restore GHR to train_history shifted by actual outcome
                next_ghr = {train_history[5:0], train_taken};
                update_ghr = 1'b1;
            end else begin
                // Normal training update
                next_ghr = {train_history[5:0], train_taken};
                update_ghr = 1'b1;
            end
        end else if (predict_valid) begin
            // Prediction update (shift in predicted taken)
            next_ghr = {ghr[5:0], predict_taken};
            update_ghr = 1'b1;
        end
    end

endmodule