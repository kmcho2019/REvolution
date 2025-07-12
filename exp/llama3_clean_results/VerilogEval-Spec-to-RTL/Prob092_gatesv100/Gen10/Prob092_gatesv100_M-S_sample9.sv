module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    // Calculate out_both
    generate
        for (i = 0; i < 100; i++) begin
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i+1];
            end else begin
                assign out_both[i] = 1'b0;
            end
        end
    endgenerate

    // Calculate out_any
    generate
        for (i = 0; i < 100; i++) begin
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i-1];
            end else begin
                assign out_any[i] = 1'b0;
            end
        end
    endgenerate

    // Calculate out_different
    generate
        for (i = 0; i < 100; i++) begin
            if (i == 99) begin
                assign out_different[i] = in[i] ^ in[0];
            end else begin
                assign out_different[i] = in[i] ^ in[i+1];
            end
        end
    endgenerate

endmodule