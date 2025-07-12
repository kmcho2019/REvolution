module TopModule (
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different
);

    // out_both implementation using generate
    always @(*) begin
        out_both[99] = 1'b0;  // Edge case
        for (int i = 0; i < 99; i = i + 1) begin
            out_both[i] = in[i] & in[i+1];
        end
    end

    // out_any implementation using generate
    always @(*) begin
        out_any[0] = 1'b0;  // Edge case
        for (int i = 1; i < 100; i = i + 1) begin
            out_any[i] = in[i] | in[i-1];
        end
    end

    // out_different implementation with explicit circular shift
    always @(*) begin
        for (int i = 0; i < 100; i = i + 1) begin
            if (i == 99)
                out_different[i] = in[i] ^ in[0];  // Wrap-around
            else
                out_different[i] = in[i] ^ in[i+1];
        end
    end

endmodule