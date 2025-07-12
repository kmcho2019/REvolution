module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (for feedback)
    input r_in,     // Load value
    input op_a,     // Additional operand for bit operations (q[1] for bit 0, q[0] for bit 1)
    input op_b,     // Second operand for bit 0 (q[2])
    output reg Q
);

    // Operation logic - depends on bit position
    wire operation = (op_b != 1'bz) ? (op_a ^ op_b) :  // Bit 0: XOR if op_b provided
                    (op_a != 1'bz) ? op_a :           // Bit 1: pass-through if op_a provided
                    q_in;                            // Bit 2: pass-through

    // Mux selects between load and operation
    wire mux_out = L ? r_in : operation;

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule