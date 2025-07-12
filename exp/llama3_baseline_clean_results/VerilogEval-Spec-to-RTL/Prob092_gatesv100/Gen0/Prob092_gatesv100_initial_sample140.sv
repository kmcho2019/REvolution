module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Out_both: both current and left neighbor are '1'
    always @(in) begin
        out_both[99] = 1'b0; // No left neighbor for in[99]
        for (int i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i + 1];
        end
    end

    // Out_any: either current or right neighbor is '1'
    always @(in) begin
        out_any[0] = 1'b0; // No right neighbor for in[0]
        for (int i = 1; i <= 99; i++) begin
            out_any[i] = in[i] | in[i - 1];
        end
    end

    // Out_different: current is different from left neighbor, wrap around for in[0]
    always @(in) begin
        for (int i = 99; i >= 1; i--) begin
            out_different[i] = ~ (in[i] === in[i - 1]);
        end
        out_different[0] = ~ (in[0] === in[99]); // Wrap around for in[0]
    end

endmodule