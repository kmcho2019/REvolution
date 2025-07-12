module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [0:31] history_bits; // 0 is youngest branch, 31 is oldest

    integer i;

    // Sequential logic: async reset and updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 32; i = i + 1) begin
                history_bits[i] <= 1'b0;
            end
        end else if (train_mispredicted) begin
            // Load train_history plus train_taken at youngest bit
            history_bits[0] <= train_taken;
            for (i = 1; i < 32; i = i + 1) begin
                history_bits[i] <= train_history[i-1];
            end
        end else if (predict_valid) begin
            // Shift left by one and insert predict_taken at youngest bit
            history_bits[0] <= predict_taken;
            for (i = 1; i < 32; i = i + 1) begin
                history_bits[i] <= history_bits[i-1];
            end
        end
        // else hold state (no change)
    end

    // Assign output concatenating bits from youngest [0] to oldest [31]
    assign predict_history = {history_bits[31], history_bits[30], history_bits[29], history_bits[28],
                              history_bits[27], history_bits[26], history_bits[25], history_bits[24],
                              history_bits[23], history_bits[22], history_bits[21], history_bits[20],
                              history_bits[19], history_bits[18], history_bits[17], history_bits[16],
                              history_bits[15], history_bits[14], history_bits[13], history_bits[12],
                              history_bits[11], history_bits[10], history_bits[9],  history_bits[8],
                              history_bits[7],  history_bits[6],  history_bits[5],  history_bits[4],
                              history_bits[3],  history_bits[2],  history_bits[1],  history_bits[0]};
endmodule