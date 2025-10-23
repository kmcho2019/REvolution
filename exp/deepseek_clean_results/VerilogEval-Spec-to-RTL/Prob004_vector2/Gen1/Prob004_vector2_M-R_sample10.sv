module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    assign out[31:24] = in[7:0];    // First byte becomes last
    assign out[23:16] = in[15:8];   // Second byte becomes third
    assign out[15:8] = in[23:16];   // Third byte becomes second
    assign out[7:0] = in[31:24];    // Last byte becomes first
endmodule