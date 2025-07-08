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
        // On misprediction, load corrected history:
        // train_history holds the older 31 bits,
        // train_taken is the newest bit,
        // so concatenation of train_taken at LSB side:
        // since predict_history[0] is youngest branch,
        // train_taken should be the LSB (bit 0),
        // so order is {train_history[31:1], train_taken}
        // but train_history is 32 bits, so to have 31 bits older
        // and 1 bit newest, take train_history[31:1] as older 31 bits?
        // The problem states train_history is 32 bits, representing history before mispredicted branch.
        // We want to put train_taken as newest bit (LSB) and older history in bits [31:1]
        // So predicted history = {train_history[31:1], train_taken};
        // But train_history[31:1] is 31 bits, train_taken 1 bit => 32 bits total.
        // That matches the problem statement "history before mispredicted branch concatenated with actual branch result".
        predict_history <= {train_history[31:1], train_taken};
    end else if (predict_valid) begin
        // Shift left by 1 and insert predict_taken as LSB (youngest)
        predict_history <= {predict_history[30:0], predict_taken};
    end
    // else hold the current value
end

endmodule