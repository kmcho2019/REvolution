module TopModule(
    input [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    if(in[3] == 1'b1)
        pos = 2'b11; // output 3
    else if(in[2] == 1'b1)
        pos = 2'b10; // output 2
    else if(in[1] == 1'b1)
        pos = 2'b01; // output 1
    else if(in[0] == 1'b1)
        pos = 2'b00; // output 0
    else
        pos = 2'b00; // output 0 if none of the bits are '1'
end

endmodule