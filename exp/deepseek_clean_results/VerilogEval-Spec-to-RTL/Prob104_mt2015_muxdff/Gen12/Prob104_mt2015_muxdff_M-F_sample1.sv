module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (for pass-through cases)
    input r_in,     // Load value
    input q0,       // Value of q[0] (for bit 1 operation)
    input q1,       // Value of q[1] (for bit 0 operation)
    input q2,       // Value of q[2] (for bit 0 operation)
    output reg Q
);

    // Operation logic for each bit position
    wire bit0_op = q1 ^ q2;  // XOR operation for bit 0
    wire bit1_op = q0;       // Pass q[0] for bit 1
    wire bit2_op = q_in;     // Pass-through for bit 2

    // Mux selects between load and operation
    wire mux_out = L ? r_in : 
                  (Q == bit0_op) ? bit0_op :  // Bit 0 operation
                  (Q == bit1_op) ? bit1_op :  // Bit 1 operation
                  bit2_op;                    // Bit 2 operation

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule