// Parameterized module to count the number of '1's in an input vector
module TopModule #(
    parameter INPUT_WIDTH = 3,  // Width of the input vector
    parameter OUTPUT_WIDTH = 2  // Width of the output vector
)(
    input [INPUT_WIDTH-1:0] in,  // Input vector
    output [OUTPUT_WIDTH-1:0] out // Output vector to hold the count
);

    // Internal signal to hold the count
    logic [OUTPUT_WIDTH-1:0] count;

    // Assign the count of '1's in the input vector to the output
    always @(*) begin
        count = 0;
        for (int i = 0; i < INPUT_WIDTH; i++) begin
            count += in[i];
        end
        out = count;
    end

endmodule