module TopModule (
    input  [99:0] in,
    output [99:0] out
);

function integer reverse_index;
    input integer idx;
    input integer width;
    begin
        reverse_index = width - 1 - idx;
    end
endfunction

genvar i;
generate
    for (i = 0; i < 100; i = i + 1) begin : reverse_bits
        assign out[i] = in[reverse_index(i, 100)];
    end
endgenerate

endmodule