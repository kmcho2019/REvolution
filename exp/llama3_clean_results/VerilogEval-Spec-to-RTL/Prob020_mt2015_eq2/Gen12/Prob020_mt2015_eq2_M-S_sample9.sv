module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);
assign z = (A == B) ? 1'b1 : 1'b0;
// The above line can be further simplified to 
// assign z = A == B;
// But we are keeping the original ternary operator form for clarity and comparison purposes.
endmodule