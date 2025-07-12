module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    integer i;

    always @(*) begin
        // out_both logic
        out_both[99] = 1'b0;  // MSB has no left neighbor
        for (i = 98; i >= 0; i = i - 1) begin
            out_both[i] = in[i] & in[i+1];
        end

        // out_any logic
        out_any[0] = 1'b0;  // LSB has no right neighbor
        for (i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end

        // out_different logic (with wrap-around)
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 99)
                out_different[i] = in[i] ^ in[0];
            else
                out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule