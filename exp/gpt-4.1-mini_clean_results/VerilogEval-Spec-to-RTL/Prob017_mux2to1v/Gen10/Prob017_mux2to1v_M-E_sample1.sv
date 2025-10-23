module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    wire [99:0] mask;
    assign mask = {100{sel}};
    assign out = (a & ~mask) | (b & mask);
endmodule