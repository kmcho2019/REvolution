module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Function to reverse a 10-bit vector
    function [9:0] reverse10;
        input [9:0] data;
        integer j;
        begin
            for (j = 0; j < 10; j = j + 1) begin
                reverse10[j] = data[9 - j];
            end
        end
    endfunction

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : rev_segments
            // Reverse each 10-bit segment and place segments in reverse order
            assign out[(i*10) +: 10] = reverse10(in[(9 - i)*10 +: 10]);
        end
    endgenerate

endmodule