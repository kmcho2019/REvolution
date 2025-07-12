module TopModule (
    input  [31:0] in,
    output [31:0] out
);

    // Declare an array of 4 bytes to hold the input bytes
    wire [7:0] bytes [0:3];

    genvar i;
    generate
        // Extract bytes from input vector
        for (i = 0; i < 4; i = i + 1) begin : extract_bytes
            assign bytes[i] = in[8*(3 - i) +: 8];
        end
    endgenerate

    // Concatenate bytes in reverse order for output
    assign out = {bytes[0], bytes[1], bytes[2], bytes[3]};

endmodule