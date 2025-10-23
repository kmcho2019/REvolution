module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Next state logic (combinational) with conditional expressions
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON)  :
                        OFF; // default to OFF on unknown

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Moore output
    assign out = state;

endmodule