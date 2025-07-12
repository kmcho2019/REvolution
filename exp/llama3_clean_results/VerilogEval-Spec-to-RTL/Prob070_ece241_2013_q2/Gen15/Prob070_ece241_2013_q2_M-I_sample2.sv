module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Assign out_sop directly from the SOP expression
always @(*)
begin
    out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);
end

// Implement out_pos using a lookup table (LUT) approach for maxterms
always @(*)
begin
    case ({a, b, c, d})
        4'b0000, 4'b0001, 4'b0100, 4'b0101, 4'b0110, 4'b1001, 4'b1010, 4'b1101, 4'b1110: out_pos = 1'b0;
        default: out_pos = 1'b1;
    endcase
end

endmodule