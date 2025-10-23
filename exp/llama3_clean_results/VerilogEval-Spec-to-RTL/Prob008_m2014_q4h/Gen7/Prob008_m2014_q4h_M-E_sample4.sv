// Module TopModule: A simple combinational logic circuit that assigns the output port 'out' to the same value as the input port 'in' using an always block.
module TopModule(
    input  logic in,  // Input port
    output logic out  // Output port
);
// Use an always block sensitive to 'in' to assign the value of 'in' to 'out'.
always @(*) begin
    out = in;
end
endmodule