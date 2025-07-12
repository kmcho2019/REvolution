module TopModule(
    input  [255:0] in,
    output [7:0] out
);

    // Define a parameter for the input width
    parameter INPUT_WIDTH = 256;

    // Calculate the number of bits required to represent the count
    parameter COUNT_WIDTH = $clog2(INPUT_WIDTH) + 1;

    // Initialize a variable to store the count
    wire [COUNT_WIDTH-1:0] count;

    // Use a hierarchical approach to count the number of '1's
    assign count = count_ones(in);

    // Assign the count to the output
    assign out = count[7:0];

    // Function to count the number of '1's in a bit vector
    function [COUNT_WIDTH-1:0] count_ones;
        input [INPUT_WIDTH-1:0] in;
        begin
            automatic reg [COUNT_WIDTH-1:0] count = 0;
            for (int i = 0; i < INPUT_WIDTH; i++) begin
                count = count + in[i];
            end
            count_ones = count;
        end
    endfunction

endmodule