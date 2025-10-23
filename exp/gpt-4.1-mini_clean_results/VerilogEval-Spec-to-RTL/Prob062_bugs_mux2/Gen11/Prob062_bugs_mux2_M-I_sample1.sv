module TopModule (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out
);
    assign out = sel ? b : a;
endmodule