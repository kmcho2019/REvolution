module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize out_both[99] to 0
        out_both[99] = 0;

        // Initialize out_any[0] to 0
        out_any[0] = 0;

        // Generate out_both
        for (i = 98; i >= 0; i--) begin
            out_both[i] = in[i] & in[i+1];
        end

        // Generate out_any
        for (i = 1; i <= 99; i++) begin
            out_any[i] = in[i] | in[i-1];
        end

        // Generate out_different
        for (i = 0; i <= 99; i++) begin
            out_different[i] = in[i] ^ in[(i+1) % 100];
        end
    end

endmodule