module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Combinational equality check using bitwise XNOR and AND
wire eq_bit0, eq_bit1;

assign eq_bit0 = (A[0] ~^ B[0]); // bit 0 equality using XNOR operator
assign eq_bit1 = (A[1] ~^ B[1]); // bit 1 equality using XNOR operator

assign z = eq_bit0 & eq_bit1;

endmodule