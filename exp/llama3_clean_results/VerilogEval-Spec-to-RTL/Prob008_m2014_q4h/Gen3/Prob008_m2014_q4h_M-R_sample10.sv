// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in'.
module TopModule(
    input  in,  // Input port
    output reg out  // Output port, declared as reg for procedural assignment
);

// Use an always block for procedural assignment.
always @(*) begin
    // Assign the value of 'in' to 'out' within the always block.
    out = in;
end

endmodule