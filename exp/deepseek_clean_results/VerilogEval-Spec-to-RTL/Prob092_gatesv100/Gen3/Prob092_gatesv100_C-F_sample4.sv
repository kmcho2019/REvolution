module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: AND current bit with left neighbor, MSB=0 (concise bitwise)
    assign out_both = {1'b0, in[98:0] & in[99:1]};

    // out_any: OR current bit with right neighbor, LSB=0 (concise bitwise)
    assign out_any = {in[99:1] | in[98:0], 1'b0};

    // out_different: explicit generate for clear wrap-around control
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : diff_loop
            if (i == 99)
                assign out_different[i] = in[i] ^ in[0];  // wrap-around case
            else
                assign out_different[i] = in[i] ^ in[i+1]; // normal case
        end
    endgenerate

endmodule