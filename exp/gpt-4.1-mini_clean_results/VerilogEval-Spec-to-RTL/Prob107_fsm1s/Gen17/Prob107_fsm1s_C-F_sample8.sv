module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state;        // current state: 0 = B, 1 = A
    wire next_state;  // next state is combinational

    // Next state logic (combinational) as continuous assignment
    assign next_state = (state == B) ? (in ? B : A)
                      : (state == A) ? (in ? A : B)
                      : B; // default to B on unexpected state

    // State register update (sequential) with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Output logic (Moore output depends only on current state)
    assign out = (state == B);

endmodule