module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    reg [99:0] shifted_in;

    always @(*) begin
        shifted_in = {in[0], in[99:1]}; // Rotate the input vector
    end

    genvar i;
    generate
        for (i = 0; i < 100; i++) begin
            assign out_both[i] = (i < 99) ? (in[i] && in[i+1]) : 0;
            assign out_any[i] = (i > 0) ? (in[i] || in[i-1]) : 0;
            assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate

    // Alternatively, using the shifted_in for out_any and out_different
    // genvar j;
    // generate
    //     for (j = 0; j < 100; j++) begin
    //         assign out_any[j] = in[j] || shifted_in[j];
    //         assign out_different[j] = in[j] ^ shifted_in[j];
    //     end
    // endgenerate

endmodule