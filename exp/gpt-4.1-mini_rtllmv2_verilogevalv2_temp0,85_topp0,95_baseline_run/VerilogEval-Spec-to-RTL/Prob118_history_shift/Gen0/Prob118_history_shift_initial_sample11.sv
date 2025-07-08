module TopModule(
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // train_history is full 32 bits; per spec it is history before the mispredicted branch
            // The actual branch outcome (train_taken) is concatenated to it as the youngest bit
            // So the new history = {train_history[30:0], train_taken}
            // But train_history is 32 bits, so to get 31 bits:
            // The spec says train_history concatenated with train_taken means:
            // treat train_history as the history before the mispredicted branch,
            // which means the 31 older bits, and train_taken the new bit.
            // So we take train_history[30:0] + train_taken as LSB
            // i.e. predict_history = {train_history[30:0], train_taken}
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // shift left by 1, insert predict_taken at LSB (youngest bit)
            predict_history <= {predict_history[30:0], predict_taken};
        end
    end

endmodule