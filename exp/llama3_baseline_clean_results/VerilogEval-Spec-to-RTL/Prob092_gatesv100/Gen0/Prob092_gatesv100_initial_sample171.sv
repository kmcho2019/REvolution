module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Initialize output bits
    integer i;

    // Calculate out_both
    always @(*) begin
        out_both[99] = 0; // No neighbor to the left
        for (i = 98; i >= 0; i--) begin
            out_both[i] = in[i] && in[i+1];
        end
    end

    // Calculate out_any
    always @(*) begin
        out_any[0] = 0; // No neighbor to the right
        for (i = 1; i <= 99; i++) begin
            out_any[i] = in[i] || in[i-1];
        end
    end

    // Calculate out_different
    always @(*) begin
        for (i = 0; i < 99; i++) begin
            out_different[i] = in[i] != in[i+1];
        end
        out_different[99] = in[99] != in[0]; // Wrap around for MSB
    end

endmodule