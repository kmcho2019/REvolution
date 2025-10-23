module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Assign out_sop directly from the SOP expression
assign out_sop = (~a & b & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Implement out_pos using a lookup table (LUT) approach
always @(*)
begin
    case ({a, b, c, d})
        4'b0010: out_pos = 1'b1; // 2
        4'b0111: out_pos = 1'b1; // 7
        4'b1111: out_pos = 1'b1; // 15
        default: out_pos = 1'b0;
    endcase
end

endmodule