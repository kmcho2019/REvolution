module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Define the LUT as a case statement for simplicity
always @(*) begin
    case ({a, b, c, d})
        4'b0000: {out, out_n} = 2'b00; // a=0, b=0, c=0, d=0
        4'b0001: {out, out_n} = 2'b00; // a=0, b=0, c=0, d=1
        4'b0010: {out, out_n} = 2'b00; // a=0, b=0, c=1, d=0
        4'b0011: {out, out_n} = 2'b01; // a=0, b=0, c=1, d=1
        4'b0100: {out, out_n} = 2'b00; // a=0, b=1, c=0, d=0
        4'b0101: {out, out_n} = 2'b01; // a=0, b=1, c=0, d=1
        4'b0110: {out, out_n} = 2'b01; // a=0, b=1, c=1, d=0
        4'b0111: {out, out_n} = 2'b01; // a=0, b=1, c=1, d=1
        4'b1000: {out, out_n} = 2'b01; // a=1, b=0, c=0, d=0
        4'b1001: {out, out_n} = 2'b01; // a=1, b=0, c=0, d=1
        4'b1010: {out, out_n} = 2'b01; // a=1, b=0, c=1, d=0
        4'b1011: {out, out_n} = 2'b01; // a=1, b=0, c=1, d=1
        4'b1100: {out, out_n} = 2'b01; // a=1, b=1, c=0, d=0
        4'b1101: {out, out_n} = 2'b01; // a=1, b=1, c=0, d=1
        4'b1110: {out, out_n} = 2'b01; // a=1, b=1, c=1, d=0
        4'b1111: {out, out_n} = 2'b01; // a=1, b=1, c=1, d=1
        default: {out, out_n} = 2'b00; // Default case, should not occur
    endcase
end

endmodule