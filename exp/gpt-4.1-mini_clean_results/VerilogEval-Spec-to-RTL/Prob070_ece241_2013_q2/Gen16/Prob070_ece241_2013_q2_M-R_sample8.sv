module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

    // Combine inputs into a 4-bit vector for convenience
    wire [3:0] in_vec = {a,b,c,d};

    always @(*) begin
        // Default outputs for don't care inputs and others
        out_sop = 0;
        out_pos = 1;

        case (in_vec)
            4'd2:  begin out_sop = 1; out_pos = 0; end // 0010
            4'd7:  begin out_sop = 1; out_pos = 0; end // 0111
            4'd15: begin out_sop = 1; out_pos = 0; end // 1111

            4'd0, 4'd1, 4'd4, 4'd5, 4'd6,
            4'd9, 4'd10, 4'd13, 4'd14:
                begin out_sop = 0; out_pos = 1; end

            // 3,8,11,12 never occur: outputs remain at default (out_sop=0,out_pos=1)
            default: begin out_sop = 0; out_pos = 1; end
        endcase
    end

endmodule