module TopModule (
    input  [15:0] in,
    output logic [7:0] out_hi,
    output logic [7:0] out_lo
);

    always_comb begin
        // Upper byte extraction (bits 15-8)
        out_hi = in[15 -: 8];  // Equivalent to in[15:8]
        
        // Lower byte extraction (bits 7-0)
        out_lo = in[7:0];
    end

    /* Alternative expressions that synthesize identically:
    always_comb begin
        out_hi = in >> 8;
        out_lo = in[0 +: 8];  // +: operator for range selection
    end
    */

endmodule