module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Function to reverse bits in a vector
    function [15:0] reverse_bits;
        input [15:0] data;
        integer i;
        begin
            for (i = 0; i < 16; i = i + 1)
                reverse_bits[i] = data[15-i];
        end
    endfunction

    wire [15:0] reversed_in = reverse_bits(in);
    wire [7:0] reversed_hi = reversed_in[15:8];
    wire [7:0] reversed_lo = reversed_in[7:0];

    assign out_hi = reverse_bits({8'b0, reversed_hi})[7:0];
    assign out_lo = reverse_bits({8'b0, reversed_lo})[7:0];

endmodule