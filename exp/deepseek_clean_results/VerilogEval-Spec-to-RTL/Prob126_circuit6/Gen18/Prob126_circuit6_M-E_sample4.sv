module TopModule (
    input [2:0] a,
    output [15:0] q
);

function [15:0] bit_reverse;
    input [15:0] data;
    integer i;
    begin
        for (i = 0; i < 16; i = i + 1)
            bit_reverse[i] = data[15 - i];
    end
endfunction

wire [15:0] expanded = {4{a}};
wire [15:0] reversed = bit_reverse(expanded);
wire [15:0] xored = reversed ^ 16'h5A5A;
wire [15:0] offset = xored + {a, a, a, a, a, a, a, 2'b00};
wire [15:0] rotated = (offset >> a) | (offset << (16 - a));

assign q = rotated ^ 16'h0F0F;

endmodule