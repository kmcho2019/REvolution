module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out_sop, // Declare out_sop as reg
    output reg out_pos  // Declare out_pos as reg
);

// Generate the output based on the input conditions
always @(a, b, c, d) begin
    // Implement the sum-of-products logic directly
    if ({a, b, c, d} == 4'b0010 || {a, b, c, d} == 4'b0111 || {a, b, c, d} == 4'b1111) begin
        out_sop = 1'b1;
    end else begin
        out_sop = 1'b0;
    end
    
    // Implement the product-of-sums logic directly
    if ({a, b, c, d} == 4'b0000 || {a, b, c, d} == 4'b0001 || {a, b, c, d} == 4'b0100 ||
        {a, b, c, d} == 4'b0101 || {a, b, c, d} == 4'b0110 || {a, b, c, d} == 4'b1001 ||
        {a, b, c, d} == 4'b1010 || {a, b, c, d} == 4'b1101 || {a, b, c, d} == 4'b1110) begin
        out_pos = 1'b0;
    end else begin
        out_pos = 1'b1;
    end
end

endmodule