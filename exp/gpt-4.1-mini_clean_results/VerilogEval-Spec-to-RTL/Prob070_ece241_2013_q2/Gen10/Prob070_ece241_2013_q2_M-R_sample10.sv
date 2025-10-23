module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector for easy decoding:
    wire [3:0] in_vec = {a, b, c, d};

    always @(*) begin
        // Default outputs
        out_sop = 1'b0;
        out_pos = 1'b1;

        // Define logic-1 outputs for out_sop on inputs 2,7,15
        // logic-0 outputs on 0,1,4,5,6,9,10,13,14
        // inputs 3,8,11,12 are don't-cares and won't appear
        case (in_vec)
            4'd2: out_sop = 1'b1;  // 0010
            4'd7: out_sop = 1'b1;  // 0111
            4'd15: out_sop = 1'b1; // 1111

            4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: out_sop = 1'b0;

            default: out_sop = 1'bx; // Don't care for 3,8,11,12
        endcase

        // For out_pos, logic-0 on minterms (2,7,15), logic-1 on maxterms:
        // The same logic reversed:
        case (in_vec)
            4'd2,4'd7,4'd15: out_pos = 1'b0; 
            4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: out_pos = 1'b1;
            default: out_pos = 1'bx;
        endcase
    end

endmodule