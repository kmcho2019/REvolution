module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output reg [WIDTH-1:0] out
);

    // Combinational logic block to update the output
    always @(*) begin
        // Loop through each bit of the input
        for (integer i = 0; i < WIDTH; i++) begin
            // Assign the input bit to the corresponding output bit in the reversed order
            out[WIDTH - 1 - i] = in[i];
        end
    end

endmodule