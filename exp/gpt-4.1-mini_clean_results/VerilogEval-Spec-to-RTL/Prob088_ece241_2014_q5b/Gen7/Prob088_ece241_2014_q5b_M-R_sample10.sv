module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

    // Binary encoding for states
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;

    // Asynchronous active-high reset, state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= (state == A && x) ? B : B;  // next state logic inlined here
    end

    // Next state logic can also be computed combinationally for clarity
    // but here it is inlined in the sequential block for demonstration.

    // Output logic (Mealy): depends on state and input x
    assign z = (state == A) ? x : ~x;

endmodule