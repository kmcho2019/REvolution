// Module to count the number of '1's in a 3-bit input vector
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the count
);

    // Assign the count of '1's in the input vector to the output
    // Using a temporary variable for better readability
    reg [1:0] count;
    always @(*) begin
        count = in[0] + in[1] + in[2];
        out = count;
    end

endmodule