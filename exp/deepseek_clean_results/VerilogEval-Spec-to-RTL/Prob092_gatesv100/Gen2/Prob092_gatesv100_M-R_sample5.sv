module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;

    always @(*) begin
        // out_both calculation
        out_both[99] = 1'b0;  // Edge case
        for (i = 98; i >= 0; i = i - 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any calculation
        out_any[0] = 1'b0;  // Edge case
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different calculation (circular)
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 99)
                out_different[i] = in[i] ^ in[0];
            else
                out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule