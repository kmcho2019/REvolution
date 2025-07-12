module TopModule (
    input clk,
    input L,
    input q_in,     // Current bit value (for pass-through)
    input r_in,     // Load value
    input q_prev,   // Previous bit value (for bit operations)
    output reg Q
);

    // Bit position parameter (0, 1, or 2)
    parameter POS = 0;
    
    // Next state calculation
    wire next_val;
    
    generate
        if (POS == 0) begin
            // Bit 0: q[1] ^ q[2]
            assign next_val = q_in ^ q_prev;
        end
        else if (POS == 1) begin
            // Bit 1: q[0]
            assign next_val = q_prev;
        end
        else begin
            // Bit 2: pass-through
            assign next_val = q_in;
        end
    endgenerate
    
    // Mux for load/operation selection
    wire mux_out = L ? r_in : next_val;
    
    // Flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule