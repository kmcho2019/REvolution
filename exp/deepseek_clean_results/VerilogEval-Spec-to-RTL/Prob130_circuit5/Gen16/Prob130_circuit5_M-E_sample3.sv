module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Bit-sliced implementation
genvar i;
generate
for (i = 0; i < 4; i = i + 1) begin: bit_slice
    // Input selection mux (implied by case statement)
    always @(*) begin
        case ({c[3], c[1:0]})
            3'b1??: q[i] = 1'b1;  // Invalid case (c >= 4)
            3'b000: q[i] = b[i];  // Case 0
            3'b001: q[i] = e[i]; // Case 1
            3'b010: q[i] = a[i];  // Case 2
            3'b011: q[i] = d[i];  // Case 3
            default: q[i] = 1'b1; // Catch-all (shouldn't occur)
        endcase
    end
end
endgenerate

endmodule