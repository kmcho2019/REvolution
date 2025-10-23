module TopModule (
    input  wire [7:0] in,
    output wire [7:0] out
);
    // Function to reverse bits in an 8-bit vector
    function [7:0] reverse_bits;
        input [7:0] data;
        integer idx;
        begin
            reverse_bits = 8'b0;
            for (idx = 0; idx < 8; idx = idx + 1) begin
                reverse_bits[idx] = data[7 - idx];
            end
        end
    endfunction

    assign out = reverse_bits(in);
endmodule