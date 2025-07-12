module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Function to reverse byte order of a 32-bit vector
    function [31:0] reverse_bytes_32;
        input [31:0] data;
        integer i;
        begin
            reverse_bytes_32 = 32'b0;
            for (i = 0; i < 4; i = i + 1) begin
                reverse_bytes_32[(i*8)+7 -: 8] = data[((3 - i)*8)+7 -: 8];
            end
        end
    endfunction

    assign out = reverse_bytes_32(in);

endmodule