module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

    // State encoding
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic as continuous assignment
    assign next_state = (state == OFF) ? (j ? ON : OFF)
                                     : (k ? OFF : ON);

    // Synchronous state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            // Moore output depends on current state (after update)
            out <= next_state;
        end
    end

endmodule