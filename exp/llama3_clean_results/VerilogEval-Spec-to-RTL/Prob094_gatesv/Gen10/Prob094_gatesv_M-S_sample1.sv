module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            if (i == 3) begin
                assign out_both[i] = 1'b0;
                assign out_any[i] = in[i];
                assign out_different[i] = in[i] ^ in[0];
            end else if (i == 0) begin
                assign out_both[i] = in[i] & in[i+1];
                assign out_any[i] = in[i];
                assign out_different[i] = in[i] ^ in[i+1];
            end else begin
                assign out_both[i] = in[i] & in[i+1];
                assign out_any[i] = in[i] | in[i-1];
                assign out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate
endmodule