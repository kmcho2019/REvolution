module TopModule(
    input            clk,
    input            areset,
    input            predict_valid,
    input            predict_taken,
    input            train_mispredicted,
    input            train_taken,
    input [31:0]     train_history,
    output [31:0]    predict_history
);

reg [31:0] history_reg [0:31];
reg [4:0] pointer;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        pointer <= 5'd0;
        for (int i = 0; i < 32; i++) begin
            history_reg[i] <= 1'd0;
        end
    end else begin
        if (train_mispredicted) begin
            for (int i = 0; i < 31; i++) begin
                history_reg[pointer + i] <= train_history[31 - i];
            end
            history_reg[pointer + 31] <= train_taken;
        end else if (predict_valid) begin
            history_reg[pointer] <= predict_taken;
            pointer <= (pointer + 1) % 32;
        end
    end
end

always @(*) begin
    predict_history = {history_reg[pointer + 30], history_reg[pointer + 29], history_reg[pointer + 28], history_reg[pointer + 27], history_reg[pointer + 26], history_reg[pointer + 25], history_reg[pointer + 24], history_reg[pointer + 23], history_reg[pointer + 22], history_reg[pointer + 21], history_reg[pointer + 20], history_reg[pointer + 19], history_reg[pointer + 18], history_reg[pointer + 17], history_reg[pointer + 16], history_reg[pointer + 15], history_reg[pointer + 14], history_reg[pointer + 13], history_reg[pointer + 12], history_reg[pointer + 11], history_reg[pointer + 10], history_reg[pointer + 9], history_reg[pointer + 8], history_reg[pointer + 7], history_reg[pointer + 6], history_reg[pointer + 5], history_reg[pointer + 4], history_reg[pointer + 3], history_reg[pointer + 2], history_reg[pointer + 1], history_reg[pointer]};
end

endmodule