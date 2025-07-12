module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

    // Use a single assign statement with a loop to reverse the bits
    assign out = { >> {WIDTH{1'b0}} }; // Initialize with zeros
    always @(*) begin
        for (int i = 0; i < WIDTH; i++) begin
            out[WIDTH - 1 - i] = in[i];
        end
    end

endmodule