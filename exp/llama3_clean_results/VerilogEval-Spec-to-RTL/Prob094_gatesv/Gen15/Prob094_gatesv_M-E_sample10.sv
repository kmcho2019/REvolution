module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 4; i++) begin
            // out_both: Check if current bit and its left neighbor are both '1'
            if (i == 3) begin
                assign out_both[i] = 1'b0;
            end else begin
                assign out_both[i] = in[i] & in[i+1];
            end

            // out_any: Check if current bit or its right neighbor is '1'
            if (i == 0) begin
                assign out_any[i] = in[i];
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end

            // out_different: Check if current bit is different from its left neighbor (wrap around for in[3])
            if (i == 3) begin
                assign out_different[i] = in[i] ^ in[0];
            end else begin
                assign out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate
endmodule