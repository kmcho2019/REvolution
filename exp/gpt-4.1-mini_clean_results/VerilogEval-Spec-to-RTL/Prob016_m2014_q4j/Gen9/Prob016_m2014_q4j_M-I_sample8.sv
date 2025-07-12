module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    assign sum = x + y; // synthesis tools infer efficient adder including overflow bit
endmodule