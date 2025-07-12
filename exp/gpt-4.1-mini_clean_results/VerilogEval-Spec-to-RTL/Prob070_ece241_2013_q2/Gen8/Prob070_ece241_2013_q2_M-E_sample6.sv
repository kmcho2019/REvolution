module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Pack the inputs into a 4-bit vector for easy case handling
    wire [3:0] in_vector;
    assign in_vector = {a,b,c,d};

    always @(*) begin
        // Default outputs in case of unspecified inputs (don't-cares)
        out_sop = 1'b0;
        out_pos = 1'b1;

        case (in_vector)
            4'd2  : begin out_sop = 1'b1; out_pos = 1'b1; end // out_pos=1 for 2, but zero for out_pos is defined later
            4'd7  : begin out_sop = 1'b1; out_pos = 1'b1; end
            4'd15 : begin out_sop = 1'b1; out_pos = 1'b1; end

            4'd0  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd1  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd4  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd5  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd6  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd9  : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd10 : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd13 : begin out_sop = 1'b0; out_pos = 1'b0; end
            4'd14 : begin out_sop = 1'b0; out_pos = 1'b0; end

            // For don't-care inputs, assign 0 to out_sop and 1 to out_pos (arbitrary)
            4'd3, 4'd8, 4'd11, 4'd12: begin out_sop = 1'b0; out_pos = 1'b1; end

            default: begin out_sop = 1'b0; out_pos = 1'b1; end
        endcase
    end

endmodule