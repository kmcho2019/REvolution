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

always @(posedge clk or posedge areset) begin
    if (areset) begin
        predict_history <= 32'b0;
    end else if (train_mispredicted) begin
        // Load with history before the mispredicted branch plus actual branch result
        // The problem statement: "train_history concatenated with train_taken"
        // train_history is 32 bits, and we have to concatenate train_taken to the LSB side
        // Since predict_history[0] is youngest branch, that means LSB is the most recent branch.
        // So concatenation means shift train_history left by 1 and set LSB to train_taken.
        // But train_history is already 32 bits, so we need to load predict_history with
        // {train_history[30:0], train_taken}
        // Because train_history represents history before the mispredicted branch (i.e. oldest is MSB).
        predict_history <= {train_history[30:0], train_taken};
    end else if (predict_valid) begin
        // Shift in predict_taken at LSB, shift history older to MSB
        // So predict_taken is the youngest branch at predict_history[0]
        predict_history <= {predict_taken, predict_history[31:1]};
    end
end

endmodule