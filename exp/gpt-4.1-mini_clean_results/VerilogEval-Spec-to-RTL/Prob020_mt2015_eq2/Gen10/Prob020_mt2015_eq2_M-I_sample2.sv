module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Compare bits explicitly using bitwise XOR and NOR to generate z
assign z = ~(|(A ^ B));

endmodule