module TopModule(
    input in1,
    input in2,
    input in3,
    output out
);

// Using the equality operator (==) for XNOR operation
// assign out = (in1 == in2) ^ in3;

// Alternative implementation using bitwise XOR and inversion for XNOR
assign out = (~(^in1 ^ in2)) ^ in3;

endmodule