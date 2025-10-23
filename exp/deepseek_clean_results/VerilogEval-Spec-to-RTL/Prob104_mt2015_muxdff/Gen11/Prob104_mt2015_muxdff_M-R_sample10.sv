module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value
    input r_in,     // Load value
    input q0,       // Value of q[0] (for bit 1)
    input q1,       // Value of q[1] (for bit 0)
    output reg Q
);

    // Mux output - use continuous assignment
    wire mux_out = L ? r_in : 
                  (q_in ? (q1 ^ Q) :  // Bit 0: q[1] ^ q[2]
                  (q0));             // Bit 1: original q[0]
                                     // Bit 2: original q[2] (passed through)

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule