module TopModule (
    input  wire       sel,
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire [7:0] out
);
    // Select entire 8-bit bus a or b based on sel
    assign out = sel ? b : a;
endmodule