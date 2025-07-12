module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

    // Function to reverse bits of a 100-bit vector
    function [99:0] bit_reverse;
        input [99:0] in_vec;
        integer idx;
        begin
            for (idx = 0; idx < 100; idx = idx + 1)
                bit_reverse[idx] = in_vec[99 - idx];
        end
    endfunction

    // Assign output using the bit_reverse function
    assign out = bit_reverse(in);

endmodule