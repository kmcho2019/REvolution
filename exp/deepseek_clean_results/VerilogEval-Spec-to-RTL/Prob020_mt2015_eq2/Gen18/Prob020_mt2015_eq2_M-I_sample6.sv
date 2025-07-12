module TopModule (
    input [1:0] A,
    input [1:0] B,
    output reg z
);
    // Optimal equality comparator - synthesizes to 2 XNORs + AND
    // Maintains minimal logic depth (2 levels)
    always @(*) begin
        z = (A == B);  // Equivalent to: (A[1] ~^ B[1]) & (A[0] ~^ B[0])
    end
endmodule