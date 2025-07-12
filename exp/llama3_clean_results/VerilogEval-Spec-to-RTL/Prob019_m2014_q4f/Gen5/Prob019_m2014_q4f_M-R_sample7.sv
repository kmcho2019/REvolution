// TopModule: A simple digital circuit implementing an AND gate with one inverted input.
module TopModule(
    input  in1,  // First input to the AND gate.
    input  in2,  // Second input to the AND gate, inverted.
    output out    // Output of the AND gate.
);

// Using a combinational always block to implement the AND operation with an inverted input.
always @(*) begin
    // The AND operation with an inverted input is directly implemented.
    out = in1 & ~in2;  // out is true only if in1 is true and in2 is false.
end

endmodule