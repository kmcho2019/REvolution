module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);

    localparam BYTE_WIDTH = 8;
    localparam MSB = 15;
    localparam LSB = 0;

    assign out_hi = in[MSB:MSB-BYTE_WIDTH+1];  // Upper byte with parameterized width
    assign out_lo = in[BYTE_WIDTH-1:LSB];     // Lower byte with parameterized width

endmodule