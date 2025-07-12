module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Split 16-bit input into upper and lower bytes
    parameter UPPER_BYTE = 15:8;
    parameter LOWER_BYTE = 7:0;
    
    assign out_hi = in[UPPER_BYTE];
    assign out_lo = in[LOWER_BYTE];

endmodule