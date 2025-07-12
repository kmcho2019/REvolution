// Define a parameterizable module for driving a constant value.
module TopModule #(
    parameter WIDTH = 1 // Parameter for output width
) (
    output logic [WIDTH-1:0] one // Output port with parameterized width
);

// Use a for loop to assign the constant value to each bit of the output.
always_comb begin
    for (int i = 0; i < WIDTH; i++) begin
        one[i] = 1'b1; // Assign 1 to each bit of the output.
    end
end

endmodule