module TopModule (
    input  [15:0] in,
    output [7:0]  out_hi,
    output [7:0]  out_lo
);
    // Intermediate wire concatenating high and low bytes (reconstructed from slices)
    wire [15:0] combined = {in[15:8], in[7:0]};

    // Assign outputs by slicing the combined wire
    assign out_hi = combined[15:8];
    assign out_lo = combined[7:0];
endmodule