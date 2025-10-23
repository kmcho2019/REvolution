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

    reg [31:0] history_reg;
    wire [31:0] next_history;
    wire reg_enable;

    // Enable register only when updates are needed
    assign reg_enable = areset | train_mispredicted | predict_valid;

    // Next state logic with clear priority
    assign next_history = train_mispredicted ? {train_history[30:0], train_taken} :
                          predict_valid     ? {history_reg[30:0], predict_taken} :
                          history_reg;

    // Register update with enable optimization hint
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (reg_enable) begin
            history_reg <= next_history;
        end
    end

    assign predict_history = history_reg;

endmodule