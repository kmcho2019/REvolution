module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// Use a combinational always block to explicitly define the comparison logic
always_comb begin
    // Direct comparison of A and B, assigning the result to z
    z = (A == B) ? 1'b1 : 1'b0;
end

endmodule