// TopModule: a full adder implemented using a look-up table (LUT)
module TopModule(
    input  a,  // first input bit
    input  b,  // second input bit
    input  cin,  // carry-in bit
    output reg cout,  // carry-out bit
    output reg sum  // sum bit
);

// Use a case statement to implement the LUT
always @(*) begin
    case ({a, b, cin})
        3'b000: {cout, sum} = 2'b00;
        3'b001: {cout, sum} = 2'b01;
        3'b010: {cout, sum} = 2'b01;
        3'b011: {cout, sum} = 2'b10;
        3'b100: {cout, sum} = 2'b01;
        3'b101: {cout, sum} = 2'b10;
        3'b110: {cout, sum} = 2'b10;
        3'b111: {cout, sum} = 2'b11;
        default: {cout, sum} = 2'b00;
    endcase
end

endmodule