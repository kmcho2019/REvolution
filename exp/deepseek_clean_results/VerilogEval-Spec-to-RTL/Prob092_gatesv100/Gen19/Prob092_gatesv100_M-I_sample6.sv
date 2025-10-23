module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin : output_gen
            wire left = in[(i+1)%100];  // Automatic wrap-around
            wire current = in[i];
            wire right = (i == 0) ? 1'b0 : in[i-1];

            // Shared logic for out_both and out_any
            assign out_both[i] = (i == 99) ? 1'b0 : current & left;
            assign out_any[i] = (i == 0) ? 1'b0 : current | right;
            
            // Simplified wrap-around using modulo
            assign out_different[i] = current ^ left;
        end
    endgenerate

endmodule