module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [7:0] bytes_in [3:0];
wire [7:0] bytes_out [3:0];

// Split input into bytes
generate
    for (i = 0; i < 4; i = i + 1) begin : split_bytes
        assign bytes_in[i] = in[8*i +: 8];
    end
endgenerate

// Reverse the byte order
generate
    for (i = 0; i < 4; i = i + 1) begin : reverse_bytes
        assign bytes_out[i] = bytes_in[3 - i];
    end
endgenerate

// Concatenate reversed bytes into output
assign out = {bytes_out[3], bytes_out[2], bytes_out[1], bytes_out[0]};

endmodule