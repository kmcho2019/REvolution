module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Combinational next-state logic optimized to simple conditional expression
    always @(*) begin
        next_state = (state == B) ? (~in) : in;
    end

    // Sequential state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Moore FSM output logic
    assign out = (state == B);

endmodule