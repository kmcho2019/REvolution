module TopModule(
    input wire [99:0] a,
    input wire [99:0] b,
    input wire sel,
    output wire [99:0] out
);
    
assign out = sel ? b : a;

endmodule