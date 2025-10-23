module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output      out_pos
);

wire [3:0] in_vec = {a, b, c, d};

always @(*) begin
    case (in_vec)
        4'd2, 4'd7, 4'd15: out_sop = 1'b1;
        4'd0, 4'd1, 4'd4, 4'd5, 4'd6, 4'd9, 4'd10, 4'd13, 4'd14: out_sop = 1'b0;
        default: out_sop = 1'b0; // For inputs that never occur
    endcase
end

// Minimal POS: (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)
assign out_pos = (a | b | ~c | d) &
                 (a | ~b |  c | d) &
                 (~a | b |  c | d);

endmodule