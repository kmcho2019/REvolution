// TopModule: A submodule containing a 2:1 multiplexer and a flip-flop.
// The output Q is updated at the positive edge of the clock based on the value of L.
// If L is high, Q is loaded with r_in; otherwise, Q retains the previous value of q_in.

module TopModule (
    input  clk, // Clock signal
    input  L,   // Load signal
    input  q_in, // Input for the flip-flop (previous state)
    input  r_in, // Input for loading when L is high
    output reg Q  // Output of the flip-flop
);

    // Update Q at the positive edge of the clock
    always @(posedge clk) begin
        // If L is high, load Q with r_in; otherwise, Q retains the value of q_in
        Q <= L? r_in : q_in;
    end

endmodule