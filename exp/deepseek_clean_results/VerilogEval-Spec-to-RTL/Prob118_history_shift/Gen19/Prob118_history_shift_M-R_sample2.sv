module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;
    wire [31:0] next_history;

    // Priority logic implemented with continuous assignments
    assign next_history = areset ? 32'b0 :
                         train_mispredicted ? {train_history[30:0], train_taken} :
                         predict_valid ? {history[30:0], predict_taken} :
                         history;

    // Register update
    always @(posedge clk) begin
        history <= next_history;
    end

    assign predict_history = history;

endmodule