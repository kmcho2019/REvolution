module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [7:0] bytes_in [3:0];
wire [7:0] bytes_out [3:0];

generate
    for (i = 0; i < 4; i = i + 1) begin : byte_reverse
        assign bytes_in[i] = in[8*i +: 8];
        assign bytes_out[i] = bytes_in[3 - i];
    end
endgenerate

assign out = {bytes_out[3], bytes_out[2], bytes_out[1], bytes_out[0]};

endmodule