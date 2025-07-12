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
    wire clk_enable;
    wire [31:0] next_history;

    // Clock gating control
    assign clk_enable = areset | predict_valid | train_mispredicted;

    // Next state computation
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid ? {history[30:0], predict_taken} :
                          history;

    // Clock-gated register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (clk_enable) begin
            history <= next_history;
        end
    end

    // Direct output assignment
    assign predict_history = history;

endmodule