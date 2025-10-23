// Novel architectural solution for implementing a NOR gate
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Using an always block to define the NOR operation based on a truth table
always @(*)
begin
    if (!(a || b))  // If both a and b are 0 (false), out should be 1 (true)
        out = 1'b1;
    else  // In all other cases, out should be 0 (false)
        out = 1'b0;
end

endmodule