module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize out_both[99] to 0 as per the problem statement
        out_both[99] = 0;

        // Initialize out_any[0] to 0 as per the problem statement
        out_any[0] = 0;

        for (i = 98; i >= 0; i--) begin
            // out_both: Both the current bit and its left neighbor are '1'
            out_both[i] = in[i] & in[i + 1];
        end

        for (i = 1; i <= 99; i++) begin
            // out_any: Either the current bit or its right neighbor is '1'
            out_any[i] = in[i] | in[i - 1];
        end

        for (i = 0; i <= 99; i++) begin
            // out_different: The current bit is different from its left neighbor (wrap-around for the most significant bit)
            if (i == 0) begin
                out_different[i] = in[i] ^ in[99];
            end else begin
                out_different[i] = in[i] ^ in[i - 1];
            end
        end
    end

endmodule