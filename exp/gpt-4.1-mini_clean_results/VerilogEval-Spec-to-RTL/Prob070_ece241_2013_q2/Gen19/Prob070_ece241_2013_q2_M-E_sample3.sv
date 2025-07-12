module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);
    wire [3:0] x;
    assign x = {a,b,c,d};

    // Optional: explicit mapping for verification, not synthesized
    reg out_ref;
    always @(*) begin
        case (x)
            4'd2 : out_ref = 1'b1; // 0010
            4'd7 : out_ref = 1'b1; // 0111
            4'd15: out_ref = 1'b1; // 1111

            4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14:
                 out_ref = 1'b0;

            default: out_ref = 1'bx; // 3,8,11,12 never occur
        endcase
    end

    // Minimal SOP (sum-of-products):
    assign out_sop = (~a & ~b &  c & ~d)  // 2
                   | (~a &  b &  c &  d)  // 7
                   | ( a &  b &  c &  d); // 15

    // Minimal POS (product-of-sums):
    assign out_pos = (a | b | ~c)
                   & (a | ~b | d)
                   & (~a | b | c | ~d);

endmodule