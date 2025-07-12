// Module TopModule: An alternative implementation using an always block to assign the input port 'in' to the output port 'out'.
module TopModule(
    input  in,  // Input port
    output reg out  // Output port, declared as reg for use within always block
);

// Use an always block to assign the value of 'in' to 'out'. This approach is more procedural and can be used for more complex logic.
always @(*) begin
    out = in;  // Assign 'in' to 'out' within the always block
end

endmodule