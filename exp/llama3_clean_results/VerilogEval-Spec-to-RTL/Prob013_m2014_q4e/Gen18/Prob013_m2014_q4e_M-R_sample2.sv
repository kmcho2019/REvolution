module TopModule(
    input  in1,
    input  in2,
    output reg out // Declare out as a reg type for use in always block
);

// Use an always block with a sensitivity list including all inputs
always @(*)
begin
    // Compute the output as the logical NOR of the inputs
    out = ~(in1 | in2);
end

endmodule