module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Use Verilog equality operator for clean, efficient comparison
assign z = (A == B);

endmodule