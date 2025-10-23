module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding (1-bit)
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Next state combinational logic (Moore FSM)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON ) ? (k ? OFF : ON ) :
                        OFF; // default safe state

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore): output follows current state
    assign out = state;

endmodule