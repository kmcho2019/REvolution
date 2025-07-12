module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire [3:0] addr;
reg q_reg;

assign addr = {a,b,c,d};

always @(*) begin
    // LUT derived from waveform table for q based on input addr = abcd
    case (addr)
        4'b0000: q_reg = 1'b1;
        4'b0001: q_reg = 1'b0;
        4'b0010: q_reg = 1'b0;
        4'b0011: q_reg = 1'b1;
        4'b0100: q_reg = 1'b0;
        4'b0101: q_reg = 1'b1;
        4'b0110: q_reg = 1'b1;
        4'b0111: q_reg = 1'b0;
        4'b1000: q_reg = 1'b0;
        4'b1001: q_reg = 1'b1;
        4'b1010: q_reg = 1'b1;
        4'b1011: q_reg = 1'b0;
        4'b1100: q_reg = 1'b1;
        4'b1101: q_reg = 1'b0;
        4'b1110: q_reg = 1'b0;
        4'b1111: q_reg = 1'b1;
        default: q_reg = 1'b0; // default case, should never occur
    endcase
end

assign q = q_reg;

endmodule