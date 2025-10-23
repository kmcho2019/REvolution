module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

    // Define the LUT as a localparam, indexed by {x3, x2, x1}
    localparam [7:0] LUT = 8'b10011000; // bit0=000, bit7=111 (reversed bit order)

    wire [2:0] idx = {x3, x2, x1};

    // Assign output f by indexing LUT at position idx.
    // Since Verilog indexing uses MSB to LSB, we invert idx for correct bit order.
    assign f = LUT[{x3,x2,x1}];

endmodule