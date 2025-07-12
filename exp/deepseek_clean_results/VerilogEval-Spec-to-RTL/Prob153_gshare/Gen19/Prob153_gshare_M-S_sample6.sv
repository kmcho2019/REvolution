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

    // Shared XOR for index calculation
    wire [6:0] current_index = predict_valid ? (predict_pc ^ ghr) : (train_pc ^ train_history);

    // Prediction output
    assign predict_taken = pht[predict_pc ^ ghr][1];
    assign predict_history = ghr;

    // Next GHR value (training has priority)
    wire [6:0] next_ghr = train_valid ? {train_history[5:0], train_taken} :
                         predict_valid ? {ghr[5:0], predict_taken} :
                         ghr;

    // PHT update logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHR and initialize PHT to weakly taken
            ghr <= 7'b0;
            for (integer i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Update GHR
            ghr <= next_ghr;

            // Update PHT only when training and not at saturation
            if (train_valid) begin
                if (train_taken && pht[current_index] != 2'b11)
                    pht[current_index] <= pht[current_index] + 1;
                else if (!train_taken && pht[current_index] != 2'b00)
                    pht[current_index] <= pht[current_index] - 1;
            end
        end
    end

endmodule