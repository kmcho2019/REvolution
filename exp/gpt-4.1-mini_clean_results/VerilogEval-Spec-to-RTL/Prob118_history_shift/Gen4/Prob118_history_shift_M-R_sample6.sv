module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [32:0] history_reg;
    wire [32:0] next_history;

    // Combinational logic to determine next history value
    assign next_history = train_mispredicted ? {train_history, train_taken} :
                          predict_valid      ? {history_reg[31:0], predict_taken} :
                                               history_reg;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 33'b0;
        end else begin
            history_reg <= next_history;
        end
    end

    // Output the lower 32 bits (bit 0 is youngest branch)
    assign predict_history = history_reg[31:0];

endmodule