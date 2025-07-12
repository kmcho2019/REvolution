module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    always @(in) begin
        for (int i = 0; i <= 99; i++) begin
            // Calculate out_both
            if (i == 99) begin
                out_both[99] = 0;
            end else begin
                out_both[i] = in[i] & in[i + 1];
            end

            // Calculate out_any
            if (i == 0) begin
                out_any[0] = 0;
            end else begin
                out_any[i] = in[i] | in[i - 1];
            end

            // Calculate out_different
            if (i == 99) begin
                out_different[99] = in[99] != in[0];
            end else begin
                out_different[i] = in[i] != in[i + 1];
            end
        end
    end

endmodule