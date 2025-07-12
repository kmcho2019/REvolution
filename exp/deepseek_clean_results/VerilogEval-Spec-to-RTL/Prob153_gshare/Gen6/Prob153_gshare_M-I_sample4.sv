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

    // Global History Register
    reg [6:0] ghr;
    
    // Pattern History Table (128 entries x 2 bits)
    reg [1:0] pht [0:127];
    
    // Prediction path (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    assign predict_taken = pht[predict_index][1];
    assign predict_history = ghr;
    
    // Training path
    wire [6:0] train_index = train_pc ^ train_history;
    reg [1:0] pht_update;
    
    // Next GHR value (prediction path)
    wire [6:0] next_pred_ghr = {ghr[5:0], predict_taken};
    
    // PHT update logic
    always @(*) begin
        if (train_valid) begin
            case (pht[train_index])
                2'b00: pht_update = train_taken ? 2'b01 : 2'b00;
                2'b01: pht_update = train_taken ? 2'b10 : 2'b00;
                2'b10: pht_update = train_taken ? 2'b11 : 2'b01;
                2'b11: pht_update = train_taken ? 2'b11 : 2'b10;
                default: pht_update = pht[train_index];
            endcase
        end
    end
    
    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR
            ghr <= 7'b0;
            
            // Initialize PHT to weakly not-taken
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
        end else begin
            // Priority: Training updates first
            if (train_valid) begin
                // Update PHT
                pht[train_index] <= pht_update;
                
                // Update GHR if mispredicted
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end 
            // Only update GHR for prediction if no training is happening
            else if (predict_valid) begin
                ghr <= next_pred_ghr;
            end
        end
    end

endmodule