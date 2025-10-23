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

    // 7-bit global history register
    reg [6:0] ghr;
    // Pattern history table (128 entries of 2-bit saturating counters)
    reg [1:0] pht [0:127];

    // Shared XOR for both prediction and training
    wire [6:0] xor_result = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);

    // Prediction outputs
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;

    // Sequential updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR and PHT
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;  // Weakly taken
        end else begin
            // Update PHT if training
            if (train_valid) begin
                if (train_taken && pht[xor_result] != 2'b11)
                    pht[xor_result] <= pht[xor_result] + 1;
                else if (!train_taken && pht[xor_result] != 2'b00)
                    pht[xor_result] <= pht[xor_result] - 1;
            end

            // Update GHR with priority to training mispredictions
            if (train_valid && train_mispredicted)
                ghr <= {train_history[5:0], train_taken};
            else if (predict_valid)
                ghr <= {ghr[5:0], predict_taken};
        end
    end

endmodule