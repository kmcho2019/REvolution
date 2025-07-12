module TopModule #(
    parameter BIT_POS = 0
) (
    input clk,
    input L,
    input q_in,     // Current bit value (for bit 2 pass-through)
    input r_in,     // Load value
    input q0,       // Needed for bit 1
    input q1,       // Needed for bit 0
    output reg Q
);

    // Operation result based on bit position
    wire op_result;
    
    generate
        if (BIT_POS == 0) begin
            // Bit 0: q1 XOR q2 (where q_in is q2)
            assign op_result = q1 ^ q_in;
        end
        else if (BIT_POS == 1) begin
            // Bit 1: pass-through q0
            assign op_result = q0;
        end
        else begin // BIT_POS == 2
            // Bit 2: pass-through current value
            assign op_result = q_in;
        end
    endgenerate

    // Mux selects between load and operation
    wire mux_out = L ? r_in : op_result;

    // Sequential logic for flip-flop
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule