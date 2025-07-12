module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (for bit 2 pass-through)
    input r_in,     // Load value
    input op_in,    // Operation input (q1 for bit 0, q0 for bit 1)
    output reg Q
);

    // Operation result based on bit position
    wire op_result;
    
    // For bit 0: op_in is q1, need q2 as well (passed as q_in)
    // For bit 1: op_in is q0
    // For bit 2: pass-through q_in
    assign op_result = (op_in ^ q_in) |  // Bit 0 XOR (if op_in is q1 and q_in is q2)
                      (op_in) |         // Bit 1 pass-through (if op_in is q0)
                      (q_in);            // Bit 2 pass-through

    // Mux selects between load and operation
    wire mux_out = L ? r_in : op_result;

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule