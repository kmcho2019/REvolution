module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector for easier case handling
    wire [3:0] in_vec = {a, b, c, d};

    always @(*) begin
        // Default outputs for undefined or don't care inputs
        out_sop = 1'b0;
        out_pos = 1'b1;  // POS is the complement of zeros, so default 1

        case (in_vec)
            4'd0: begin out_sop = 1'b0; out_pos = 1'b0; end  // zero-set
            4'd1: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd2: begin out_sop = 1'b1; out_pos = 1'b1; end  // ones-set
            4'd3: begin out_sop = 1'bx; out_pos = 1'bx; end  // don't care
            4'd4: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd5: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd6: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd7: begin out_sop = 1'b1; out_pos = 1'b1; end
            4'd8: begin out_sop = 1'bx; out_pos = 1'bx; end
            4'd9: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd10: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd11: begin out_sop = 1'bx; out_pos = 1'bx; end
            4'd12: begin out_sop = 1'bx; out_pos = 1'bx; end
            4'd13: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd14: begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd15: begin out_sop = 1'b1; out_pos = 1'b1; end
            default: begin out_sop = 1'b0; out_pos = 1'b1; end
        endcase
    end

endmodule