module TopModule(
    output out
);

// Direct assignment remains the most straightforward and efficient way
// to drive a constant value. This approach allows the synthesis tool
// to optimize the implementation based on the target technology.
assign out = 1'b0;

endmodule