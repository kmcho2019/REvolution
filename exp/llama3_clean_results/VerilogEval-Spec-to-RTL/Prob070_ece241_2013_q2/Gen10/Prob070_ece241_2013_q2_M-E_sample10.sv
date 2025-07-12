module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop,
    output reg out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop using case statement
always @(a, b, c, d) begin
    case ({a, b, c, d})
        4'b0010, 4'b0111, 4'b1111: out_sop = 1'b1;
        default: out_sop = 1'b0;
    endcase
end

// For out_pos, correctly derive in minimum product-of-sums form
// Given the complexity, focus on complement conditions for out_sop
always @(a, b, c, d) begin
    if ((a & ~b) || (~a & ~b & ~c & ~d) || (~a & ~b & ~c & d) || (~a & ~b & c & ~d) || (~a & ~b & c & d) ||
        (~a & b & ~c & ~d) || (~a & b & ~c & d) || (a & ~b & ~c & ~d) || (a & ~b & ~c & d) ||
        (a & ~b & c & ~d) || (a & ~b & c & d) || (~a & ~b & ~c & ~d)) begin
        out_pos = 1'b1;
    end else begin
        out_pos = 1'b0;
    end
end

endmodule