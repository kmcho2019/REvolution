module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // out_both: both current and left neighbor are 1
    always @(in) begin
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_both[99] = 1'b0; // most significant bit has no left neighbor
            end else begin
                out_both[i] = in[i] & in[i + 1];
            end
        end
    end

    // out_any: either current or right neighbor is 1
    always @(in) begin
        for (int i = 0; i < 100; i++) begin
            if (i == 0) begin
                out_any[0] = 1'b0; // least significant bit has no right neighbor
            end else begin
                out_any[i] = in[i] | in[i - 1];
            end
        end
    end

    // out_different: current is different from left neighbor (wrapping around)
    always @(in) begin
        for (int i = 0; i < 100; i++) begin
            if (i == 99) begin
                out_different[99] = in[99] != in[0]; // wrap around for most significant bit
            end else begin
                out_different[i] = in[i] != in[i + 1];
            end
        end
    end

endmodule