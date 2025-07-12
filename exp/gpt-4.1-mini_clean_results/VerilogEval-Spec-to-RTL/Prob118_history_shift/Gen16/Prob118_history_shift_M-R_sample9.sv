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

    reg [31:0] history;

    // Combinational next state logic with priority: misprediction > prediction > hold
    wire [31:0] corrected_history = {train_history, 1'b0} | 32'b1 << 0 & {31'b0, train_taken};
    wire [31:0] shifted_history   = {history[30:0], predict_taken};

    wire [31:0] next_history =
        train_mispredicted ? ({train_history, 1'b0} | (32'b1 & {31'b0, train_taken})) :
        (predict_valid ? shifted_history :
         history);

    assign predict_history = history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            history <= next_history;
        end
    end

endmodule