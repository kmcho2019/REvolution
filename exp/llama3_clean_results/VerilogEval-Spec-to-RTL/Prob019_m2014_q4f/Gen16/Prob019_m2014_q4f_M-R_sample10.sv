module TopModule(
    input  in1,
    input  in2,
    output out
);

// Using an always block to implement combinational logic
always @(*) begin
    // Perform the AND operation with in2 inverted
    out = in1 & (~in2);
end

endmodule