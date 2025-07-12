module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in;
assign in = {a,b,c,d};

reg sop_reg;
reg pos_reg;

always @(*) begin
    // Default outputs
    sop_reg = 1'b0;
    pos_reg = 1'b1;

    // Assign SOP output = 1 for inputs 2,7,15
    case (in)
        4'd2, 4'd7, 4'd15: sop_reg = 1'b1;
        4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: sop_reg = 1'b0;
        default: sop_reg = 1'b0; // inputs 3,8,11,12 never occur, default to 0
    endcase

    // Assign POS output = 0 for zeros: 0,1,4,5,6,9,10,13,14
    // POS output = 1 for 2,7,15
    case (in)
        4'd0,4'd1,4'd4,4'd5,4'd6,4'd9,4'd10,4'd13,4'd14: pos_reg = 1'b0;
        4'd2, 4'd7, 4'd15: pos_reg = 1'b1;
        default: pos_reg = 1'b1; // inputs 3,8,11,12 never occur, default to 1
    endcase
end

// Minimal SOP expression:
// from minterms 2(0010),7(0111),15(1111) and don't cares 3,8,11,12,
// minimal SOP: (b & c & d) + (~a & ~b & c) + (a & b & c & d)
assign out_sop = (b & c & d) | ((~a) & (~b) & c) | (a & b & c & d);

// Minimal POS expression covering zeros 0,1,4,5,6,9,10,13,14:
// POS: (a + b + ~c + ~d) & (a + ~b + ~c + d) & (~a + ~b + c + ~d)
assign out_pos = (a | b | (~c) | (~d)) & (a | (~b) | (~c) | d) & ((~a) | (~b) | c | (~d));

endmodule