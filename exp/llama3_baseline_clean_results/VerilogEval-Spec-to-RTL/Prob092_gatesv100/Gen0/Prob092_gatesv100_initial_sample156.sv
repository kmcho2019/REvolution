module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

genvar i;
generate
    for (i = 0; i < 100; i++) begin
        // out_both: both current and left neighbor are '1'
        if (i == 99) begin
            assign out_both[i] = 1'b0; // no left neighbor for in[99]
        end else begin
            assign out_both[i] = in[i] & in[i+1];
        end

        // out_any: either current or right neighbor is '1'
        if (i == 0) begin
            assign out_any[i] = 1'b0; // no right neighbor for in[0]
        end else begin
            assign out_any[i] = in[i] | in[i-1];
        end

        // out_different: current is different from left neighbor
        if (i == 99) begin
            assign out_different[i] = in[i] ^ in[0]; // wrap around to start for in[99]
        end else begin
            assign out_different[i] = in[i] ^ in[i+1];
        end
    end
endgenerate

endmodule