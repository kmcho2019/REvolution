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

    wire [31:0] next_history;
    reg [31:0] history_reg;

    // Combinational next-state logic
    assign next_history = areset ? 32'b0 :
                         train_mispredicted ? {train_history[30:0], train_taken} :
                         predict_valid ? {history_reg[30:0], predict_taken} :
                         history_reg;

    // Sequential element
    always @(posedge clk) begin
        history_reg <= next_history;
    end

    // Output assignment
    assign predict_history = history_reg;

endmodule