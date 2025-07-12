module TopModule(
    input  in1,
    input  in2,
    output out
);

// Use an always block to compute the output
always @(*)
begin
    // Compute the NOR of in1 and in2 using logical operators
    out = ~(in1 | in2);
end

endmodule