module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Calculate out_both: both current and left bits are 1
    always @(*) begin
        out_both[99] = 1'b0; // no left neighbor for MSB
        for (int i = 0; i < 99; i++) begin
            out_both[i] = in[i] & in[i+1];
        end
    end

    // Calculate out_any: either current or right bits are 1
    always @(*) begin
        out_any[0] = 1'b0; // no right neighbor for LSB
        for (int i = 1; i < 100; i++) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // Calculate out_different: current bit is different from left bit
    always @(*) begin
        out_different[99] = in[99] ^ in[0]; // wrap around for MSB
        for (int i = 0; i < 99; i++) begin
            out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule