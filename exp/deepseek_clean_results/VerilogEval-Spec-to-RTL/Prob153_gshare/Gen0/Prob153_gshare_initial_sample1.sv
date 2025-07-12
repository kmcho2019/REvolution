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
    
    // PHT index calculation
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;
    
    // Prediction output
    assign predict_taken = predict_valid ? pht[predict_index][1] : 1'b0;
    assign predict_history = ghr;
    
    // Initialize PHT and GHR on reset
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly not-taken initial state
            ghr <= 7'b0;
        end else begin
            // PHT update (training)
            if (train_valid) begin
                case (pht[train_index])
                    2'b00: pht[train_index] <= train_taken ? 2'b01 : 2'b00;
                    2'b01: pht[train_index] <= train_taken ? 2'b10 : 2'b00;
                    2'b10: pht[train_index] <= train_taken ? 2'b11 : 2'b01;
                    2'b11: pht[train_index] <= train_taken ? 2'b11 : 2'b10;
                endcase
            end
            
            // GHR update
            if (train_valid && train_mispredicted) begin
                // Recovery from misprediction - use train_history plus current outcome
                ghr <= {train_history[5:0], train_taken};
            end else if (train_valid) begin
                // Normal training updates GHR with actual outcome
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Prediction updates GHR with predicted outcome
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule