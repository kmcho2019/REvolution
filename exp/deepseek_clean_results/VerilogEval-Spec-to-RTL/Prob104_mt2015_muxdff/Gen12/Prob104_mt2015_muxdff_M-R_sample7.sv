module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (for bit 2 pass-through)
    input r_in,     // Load value
    input q0,       // q[0] value (for bit 1 calculation)
    input q1,       // q[1] value (for bit 0 calculation)
    output reg Q
);

    // Mux logic - select between load value and computed value
    wire next_val;
    assign next_val = L ? r_in : 
                     (Q ? (q1 ^ q_in) :  // Bit 0: q[1] ^ q[2]
                     q0);               // Bit 1: q[0]
                                         // Bit 2: q_in (pass-through)

    // Flip-flop implementation
    always @(posedge clk) begin
        Q <= next_val;
    end

endmodule