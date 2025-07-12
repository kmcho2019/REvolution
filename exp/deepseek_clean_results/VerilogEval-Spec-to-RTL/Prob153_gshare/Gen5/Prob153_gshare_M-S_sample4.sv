module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // Pattern History Table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    
    // Global History Register
    reg [6:0] ghr;
    
    // Prediction index (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    
    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ (train_mispredicted ? train_history : ghr);
    
    // PHT and GHR update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not-taken and clear GHR
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else if (train_valid) begin
            // Update PHT counter (saturating)
            if (train_taken)
                pht[train_index] <= (pht[train_index] == 2'b11) ? 2'b11 : pht[train_index] + 1;
            else
                pht[train_index] <= (pht[train_index] == 2'b00) ? 2'b00 : pht[train_index] - 1;
            
            // Update GHR (with misprediction recovery if needed)
            if (train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else
                ghr <= {ghr[5:0], train_taken};
        end else if (predict_valid) begin
            // Update GHR for prediction (only if no training)
            ghr <= {ghr[5:0], pht[predict_index][1]};
        end
    end

    // Prediction output (combinational)
    always @(*) begin
        if (predict_valid) begin
            predict_taken = pht[predict_index][1];
            predict_history = ghr;
        end else begin
            predict_taken = 1'b0;
            predict_history = 7'b0;
        end
    end

endmodule