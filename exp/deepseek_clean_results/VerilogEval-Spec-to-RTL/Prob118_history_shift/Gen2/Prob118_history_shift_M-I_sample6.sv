module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output reg [31:0] predict_history
);

    reg [31:0] history_reg;
    wire clk_enable = predict_valid || train_mispredicted;
    wire [31:0] next_history;

    // Next state logic
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                         predict_valid ? {history_reg[30:0], predict_taken} :
                         history_reg;

    // Clock gated register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (clk_enable) begin
            history_reg <= next_history;
        end
    end

    // Registered output for better timing
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_history <= 32'b0;
        end else begin
            predict_history <= history_reg;
        end
    end

endmodule