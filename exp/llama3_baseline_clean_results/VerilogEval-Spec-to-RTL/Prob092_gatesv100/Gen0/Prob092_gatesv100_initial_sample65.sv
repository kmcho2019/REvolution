module TopModule(
    input  [:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: check if current bit and its neighbor to the left are both        if (i ==) begin
            assign out_both[i] = 'b0;
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: check if current bit or its neighbor to the right are  if (i == 0) begin
            assign out_any[i] = 1'b0;
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: check if current bit is different from its neighbor to the left
        if (i == ) begin
            assign out_different[i] = in[i] ^ in[0];
        end else begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
    end
endgenerate

endmodule