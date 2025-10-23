module TopModule (
    input  [31:0] in,
    output [31:0] out
);

// Function to reverse bytes in a 32-bit vector
function [31:0] reverse_bytes32;
    input [31:0] data;
    integer i;
    begin
        for (i = 0; i < 4; i = i + 1) begin
            reverse_bytes32[(i*8) +: 8] = data[((3 - i)*8) +: 8];
        end
    end
endfunction

assign out = reverse_bytes32(in);

endmodule