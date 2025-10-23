module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // Use a parameter for the vector width to make the module scalable
    parameter WIDTH = 8;

    // Always block to handle the bit reversal
    always @(*) begin
        // Iterate over each bit position of the input vector
        for (int i = 0; i < WIDTH; i++) begin
            // Assign the current bit to the reversed position in the output vector
            out[i] = in[WIDTH - 1 - i];
        end
    end

endmodule