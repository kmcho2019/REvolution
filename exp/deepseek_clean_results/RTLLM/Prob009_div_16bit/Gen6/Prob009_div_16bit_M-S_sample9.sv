module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    wire [8:0] rem [0:15];  // 9-bit remainders (8 bits + carry)
    genvar i;

    // Initial remainder
    assign rem[15] = {1'b0, A[15]};

    // Generate the division stages
    generate
        for (i = 14; i >= 0; i = i - 1) begin : div_stages
            wire [8:0] rem_ext = {rem[i+1][7:0], A[i]};
            assign rem[i] = (rem_ext >= {1'b0, B}) ? 
                          (rem_ext - {1'b0, B}) : rem_ext;
            assign result[i] = (rem_ext >= {1'b0, B});
        end
    endgenerate

    // Final remainder output
    assign odd = {8'b0, rem[0][7:0]};

endmodule