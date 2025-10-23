module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
// The binary representations for 2, 7, and 15 are 0010, 0111, and 1111 respectively.
always @(*) begin
    out_sop = 0;
    if (!a && b && !c && !d) out_sop = 1;
    else if (!a && b && c && d) out_sop = 1;
    else if (a && b && c && d) out_sop = 1;
end

// Minimum Product-of-Sums (POS) form for out_pos
// Since out_pos is the complement of out_sop, we can simplify its implementation
always @(*) begin
    out_pos = ~out_sop;
end

endmodule