module Reverse4Bit (
    input [3:0] in,
    output [3:0] out
);
    assign out = {in[0], in[1], in[2], in[3]};
endmodule

module TopModule (
    input [7:0] in,
    output [7:0] out
);
    wire [3:0] upper_reversed;
    wire [3:0] lower_reversed;
    
    Reverse4Bit upper (.in(in[7:4]), .out(upper_reversed));
    Reverse4Bit lower (.in(in[3:0]), .out(lower_reversed));
    
    assign out = {lower_reversed, upper_reversed};
endmodule