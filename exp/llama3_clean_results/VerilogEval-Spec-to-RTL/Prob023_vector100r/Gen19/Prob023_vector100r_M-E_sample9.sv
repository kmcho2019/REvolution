module TopModule #(
    // Parameter for the width of the input and output
    parameter WIDTH = 100
) (
    // Input signal
    input  [WIDTH-1:0] in,
    // Output signal with reversed bit order
    output [WIDTH-1:0] out
);

    // Internal signal to hold the shifted input bits
    reg [WIDTH-1:0] shift_reg;

    // Initialize the shift register with zeros
    initial begin
        shift_reg = {WIDTH{1'b0}};
    end

    // Always block to perform the bit reversal
    always @(in) begin
        // Load the input bits into the shift register
        for (int i = 0; i < WIDTH; i++) begin
            // Shift the bits to the right and load the new bit
            shift_reg = {shift_reg[WIDTH-2:0], in[i]};
        end

        // Assign the shifted bits to the output
        out = shift_reg;
    end

endmodule