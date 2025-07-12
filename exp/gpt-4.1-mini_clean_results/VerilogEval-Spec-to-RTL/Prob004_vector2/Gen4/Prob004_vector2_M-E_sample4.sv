module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    wire [7:0] bytes_in [3:0];
    wire [7:0] bytes_out [3:0];

    // Split input into bytes
    assign bytes_in[0] = in[7:0];
    assign bytes_in[1] = in[15:8];
    assign bytes_in[2] = in[23:16];
    assign bytes_in[3] = in[31:24];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : byte_reverse
            assign bytes_out[i] = bytes_in[3 - i];
        end
    endgenerate

    // Recombine reversed bytes into output
    assign out = {bytes_out[3], bytes_out[2], bytes_out[1], bytes_out[0]};
endmodule