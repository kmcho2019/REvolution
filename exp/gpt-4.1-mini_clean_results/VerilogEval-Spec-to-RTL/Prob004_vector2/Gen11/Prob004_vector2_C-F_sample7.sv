module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    localparam BYTE_NUM = 4;

    // Function to reverse byte order of a 32-bit vector
    function [31:0] reverse_bytes;
        input [31:0] data_in;
        integer i;
        begin
            for (i = 0; i < BYTE_NUM; i = i + 1) begin
                reverse_bytes[i*8 +: 8] = data_in[(BYTE_NUM - 1 - i)*8 +: 8];
            end
        end
    endfunction

    assign out = reverse_bytes(in);

endmodule