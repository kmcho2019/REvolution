module TopModule(
    input  wire [99:0] a,
    input  wire [99:0] b,
    input  wire        sel,
    output wire [99:0] out
);
    wire sel_n;
    assign sel_n = ~sel;
    assign out = (a & {100{sel_n}}) | (b & {100{sel}});
endmodule