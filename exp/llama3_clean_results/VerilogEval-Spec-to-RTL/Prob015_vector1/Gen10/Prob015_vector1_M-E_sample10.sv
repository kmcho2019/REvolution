module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use bitwise operations to extract upper and lower bytes
    assign out_hi = in >> 8; // Shift input right by 8 to get upper byte
    assign out_lo = in & 8'hFF; // AND with mask to extract lower byte

endmodule