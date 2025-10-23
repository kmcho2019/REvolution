module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Logic for out_both
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            if (i < 3) begin
                assign out_both[i] = in[i] & in[i+1];
            end else begin
                assign out_both[i] = 1'b0;
            end
        end
    endgenerate

    // Logic for out_any
    genvar j;
    generate
        for (j = 0; j < 4; j++) begin
            if (j > 0) begin
                assign out_any[j] = in[j] | in[j-1];
            end else begin
                assign out_any[j] = in[j];
            end
        end
    endgenerate

    // Logic for out_different
    genvar k;
    generate
        for (k = 0; k < 4; k++) begin
            if (k == 3) begin
                assign out_different[k] = in[k] ^ in[0];
            end else begin
                assign out_different[k] = in[k] ^ in[k+1];
            end
        end
    endgenerate

endmodule