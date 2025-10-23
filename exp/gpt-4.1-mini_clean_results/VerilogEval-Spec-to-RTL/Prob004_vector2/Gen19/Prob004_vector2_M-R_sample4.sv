module TopModule (
    input  [31:0] in,
    output [31:0] out
);

wire [7:0] bytes_rev [3:0];

genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse_loop
        assign bytes_rev[i] = in[8*(3 - i) +: 8];
    end
endgenerate

assign out = {bytes_rev[0], bytes_rev[1], bytes_rev[2], bytes_rev[3]};

endmodule