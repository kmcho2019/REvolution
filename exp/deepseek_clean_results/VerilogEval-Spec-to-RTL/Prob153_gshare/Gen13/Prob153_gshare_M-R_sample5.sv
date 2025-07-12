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

    // Pattern History Table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Shared XOR for both prediction and training indices
    wire [6:0] xor_predict = predict_pc ^ ghr;
    wire [6:0] xor_train = train_pc ^ train_history;

    // Prediction output (combinational)
    assign predict_taken = pht[xor_predict][1];
    assign predict_history = ghr;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not-taken and clear GHR
            for (integer i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Handle training updates first (higher priority)
            if (train_valid) begin
                // Only update PHT if counter would actually change
                if ((train_taken && pht[xor_train] != 2'b11) || 
                    (!train_taken && pht[xor_train] != 2'b00)) begin
                    pht[xor_train] <= train_taken ? pht[xor_train] + 1 : pht[xor_train] - 1;
                end

                // Update GHR for mispredictions (recovery case)
                if (train_mispredicted) begin
                    ghr <= {train_history[5:0], train_taken};
                end
            end 
            // Then handle prediction updates if no training occurred
            else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
        end
    end

endmodule