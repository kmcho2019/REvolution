// Parameterized module to count the number of '1's in an n-bit input vector
module TopModule #(
    parameter INPUT_WIDTH = 3, // Width of the input vector
    parameter OUTPUT_WIDTH = 2 // Width of the output vector
)(
    input [INPUT_WIDTH-1:0] in,  // n-bit input vector
    output [OUTPUT_WIDTH-1:0] out // m-bit output vector to hold the count
);

    reg [OUTPUT_WIDTH-1:0] count; // Variable to hold the count
    integer i; // Loop variable

    always @(*) begin
        count = 0; // Initialize the count to 0
        for (i = 0; i < INPUT_WIDTH; i = i + 1) begin
            // If the current bit is '1', increment the count
            if (in[i] == 1'b1) begin
                count = count + 1'b1;
            end
        end
        out = count; // Assign the count to the output
    end

endmodule