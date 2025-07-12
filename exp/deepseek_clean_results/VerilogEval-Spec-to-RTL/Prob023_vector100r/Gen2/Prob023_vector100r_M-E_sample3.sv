module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Reverse each 20-bit chunk
wire [19:0] chunk0_rev = {in[19:0]};
wire [19:0] chunk1_rev = {in[39:20]};
wire [19:0] chunk2_rev = {in[59:40]};
wire [19:0] chunk3_rev = {in[79:60]};
wire [19:0] chunk4_rev = {in[99:80]};

// Reverse the order of chunks and combine
assign out = {chunk0_rev, chunk1_rev, chunk2_rev, chunk3_rev, chunk4_rev};

// Function to reverse bits in a chunk
function [19:0] reverse_bits;
    input [19:0] data;
    integer i;
    begin
        for (i = 0; i < 20; i = i + 1) begin
            reverse_bits[i] = data[19-i];
        end
    end
endfunction

endmodule