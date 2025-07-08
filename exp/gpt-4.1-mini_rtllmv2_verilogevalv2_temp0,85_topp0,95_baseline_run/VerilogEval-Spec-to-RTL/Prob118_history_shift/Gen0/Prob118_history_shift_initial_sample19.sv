module TopModule (
    input        clk,
    input        areset,
    input        predict_valid,
    input        predict_taken,
    input        train_mispredicted,
    input        train_taken,
    input  [31:0] train_history,
    output reg [31:0] predict_history
);

    // Asynchronous reset with synchronous update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else if (train_mispredicted) begin
            // Load corrected history: older history concatenated with actual branch taken
            predict_history <= {train_taken, train_history[31:1]};
            // The problem states: "train_history concatenated with train_taken"
            // The train_history is before the mispredicted branch, so it is the older 31 bits
            // Then we add train_taken as the LSB.
            // Since predict_history[0] is youngest branch, the LSB is train_taken
            // So train_history is bits 31:1, train_taken is bit 0
            // But train_history is 32 bits, so actually we want:
            // predict_history = {train_history, train_taken};
            // The problem says: "history before mispredicted branch (train_history) concatenated with train_taken"
            // That is 32 bits + 1 bit = 33 bits, but predict_history is only 32 bits
            // So possibly train_history is already 32 bits before the branch, we want to drop the oldest bit?
            // It is ambiguous, but problem states predict_history is 32 bits.
            // Possibly train_history is 31 bits (history before mispredicted branch),
            // and train_taken is the newest bit, so total 32 bits.
            // So, we assume train_history is the 31 older bits,
            // and we concatenate train_taken as the youngest bit:
            // So the corrected assignment:
            predict_history <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Shift in the predicted branch from the LSB side (youngest)
            predict_history <= {predict_taken, predict_history[31:1]};
            // Actually, the problem states predict_history[0] is youngest branch,
            // so the youngest bit is LSB.
            // To shift in predict_taken from LSB side means shift left by 1 with predict_taken as LSB:
            // So predict_history <= {predict_taken, predict_history[31:1]};
            // But that puts predict_taken into MSB, which is predict_history[31].
            // So, we must shift right by 1 bit and insert predict_taken at bit 0:
            // So:
            predict_history <= {predict_history[31:1], predict_taken};
        end
    end

endmodule