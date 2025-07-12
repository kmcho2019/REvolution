module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out
);

    // Function to reverse bits of a 100-bit vector
    function [99:0] reverse_bits_100;
        input [99:0] data_in;
        integer j;
        begin
            for (j = 0; j < 100; j = j + 1) begin
                reverse_bits_100[j] = data_in[99 - j];
            end
        end
    endfunction

    assign out = reverse_bits_100(in);

endmodule