module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    // State encoding with localparams for clarity
    localparam OFF = 1'b0,
               ON  = 1'b1;

    reg state, next_state;

    // Combinational next state logic using ternary operator for conciseness
    always @(*) begin
        next_state = (state == OFF) ? (j ? ON : OFF)
                                   : (k ? OFF : ON);
    end

    // Sequential logic: state and output update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= state;  // Output depends on current state, reflecting Moore semantics
        end
    end

endmodule