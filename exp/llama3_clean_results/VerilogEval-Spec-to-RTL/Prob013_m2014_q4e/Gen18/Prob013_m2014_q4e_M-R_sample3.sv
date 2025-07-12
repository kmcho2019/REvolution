module TopModule(
    input  in1,
    input  in2,
    output reg out
);

// Refactored implementation using an always block for procedural assignment
always @(*) begin
    // Implement the NOR gate using the logical NOR operator (~) within the always block
    out <= ~(in1 | in2);
end

endmodule