module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

always_comb begin
    // Initialize outputs
    out_both = 100'b0;
    out_any = 100'b0;
    out_different = 100'b0;

    // Generate outputs using loops
    for (int i = 0; i < 100; i = i + 1) begin
        // out_both calculation
        if (i < 99) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any calculation
        if (i > 0) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different calculation with wrap-around
        if (i == 99) begin
            out_different[i] = in[i] ^ in[0];
        end else begin
            out_different[i] = in[i] ^ in[i+1];
        end
    end
end

endmodule