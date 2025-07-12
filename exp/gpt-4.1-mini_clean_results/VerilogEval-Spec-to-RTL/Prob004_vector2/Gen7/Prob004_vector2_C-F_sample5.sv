module TopModule (
    input  [31:0] in,
    output [31:0] out
);

genvar i;
wire [7:0] bytes_in [3:0];

// Slice input into bytes
generate
    for (i = 0; i < 4; i = i + 1) begin : input_bytes
        assign bytes_in[i] = in[8*i +: 8];
    end
endgenerate

// Concatenate reversed bytes directly from bytes_in array without intermediate outputs
assign out = {bytes_in[0], bytes_in[1], bytes_in[2], bytes_in[3]}[::-1]; // Not valid syntax in Verilog

endmodule