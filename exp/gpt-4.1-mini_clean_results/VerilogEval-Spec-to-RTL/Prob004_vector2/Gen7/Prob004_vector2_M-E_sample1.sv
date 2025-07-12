module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [7:0] bytes_in [3:0];
reg  [7:0] bytes_out [3:0];

// Slice input bytes
generate
    for (i = 0; i < 4; i = i + 1) begin : IN_BYTES
        assign bytes_in[i] = in[i*8 +: 8];
    end
endgenerate

// Reverse bytes into output register
always @(*) begin
    for (integer j = 0; j < 4; j = j + 1) begin
        bytes_out[j] = bytes_in[3 - j];
    end
end

// Concatenate output bytes
assign out = {bytes_out[3], bytes_out[2], bytes_out[1], bytes_out[0]};

endmodule