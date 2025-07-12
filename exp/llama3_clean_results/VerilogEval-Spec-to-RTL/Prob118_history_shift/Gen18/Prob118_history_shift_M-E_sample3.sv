module TopModule (
    input           clk,
    input           areset,
    input           predict_valid,
    input           predict_taken,
    input           train_mispredicted,
    input           train_taken,
    input   [31:0]   train_history,
    output  [31:0]   predict_history
);

reg [31:0] fifo [0:31];
reg [5:0]  fifo_ptr;
reg [31:0] predict_history_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        fifo_ptr <= 0;
        for (int i = 0; i < 32; i++) begin
            fifo[i] <= 0;
        end
    end else if (train_mispredicted) begin
        for (int i = 0; i < 31; i++) begin
            fifo[i] <= train_history[i];
        end
        fifo[31] <= train_taken;
        fifo_ptr <= 0;
    end else if (predict_valid) begin
        for (int i = 1; i < 32; i++) begin
            fifo[i-1] <= fifo[i];
        end
        fifo[31] <= predict_taken;
    end
end

always @(posedge clk) begin
    predict_history_reg <= {fifo[31], fifo[30], fifo[29], fifo[28], fifo[27], fifo[26], fifo[25], fifo[24], fifo[23], fifo[22], fifo[21], fifo[20], fifo[19], fifo[18], fifo[17], fifo[16], fifo[15], fifo[14], fifo[13], fifo[12], fifo[11], fifo[10], fifo[9], fifo[8], fifo[7], fifo[6], fifo[5], fifo[4], fifo[3], fifo[2], fifo[1], fifo[0]};
end

assign predict_history = predict_history_reg;

endmodule