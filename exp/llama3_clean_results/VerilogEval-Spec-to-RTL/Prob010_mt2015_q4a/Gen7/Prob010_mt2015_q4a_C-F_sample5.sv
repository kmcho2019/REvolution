module TopModule(
    input  logic x,  // Input signal x
    input  logic y,  // Input signal y
    output logic z   // Output signal z
);

always @(*) begin
    z = (x ^ y) & x;  // Directly implement the boolean function
end

endmodule