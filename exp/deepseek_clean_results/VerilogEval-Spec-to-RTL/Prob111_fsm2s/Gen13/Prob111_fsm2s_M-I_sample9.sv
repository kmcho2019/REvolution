module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;
    reg last_j, last_k;
    wire clk_enable;

    // Detect input changes for clock gating
    assign clk_enable = (j != last_j) || (k != last_k);

    // Combinational next state logic (simplified)
    always @(*) begin
        case (state)
            OFF: next_state = j ? ON : OFF;
            ON:  next_state = k ? OFF : ON;
        endcase
    end

    // Sequential state update with synchronous reset and clock gating
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
            last_j <= 1'b0;
            last_k <= 1'b0;
        end else if (clk_enable) begin
            state <= next_state;
            out <= state;  // Registered output
            last_j <= j;
            last_k <= k;
        end
    end

endmodule