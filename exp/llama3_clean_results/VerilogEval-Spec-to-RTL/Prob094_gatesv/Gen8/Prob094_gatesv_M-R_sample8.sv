module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out_both,
    output [WIDTH-1:0] out_any,
    output [WIDTH-1:0] out_different
);

    integer i;

    always @(*) begin
        // Initialize outputs to avoid latch inference
        out_both = {WIDTH{1'b0}};
        out_any = {WIDTH{1'b0}};
        out_different = {WIDTH{1'b0}};

        // Calculate out_both
        for (i = 0; i < WIDTH - 1; i++) begin
            out_both[i] = in[i] & in[i + 1];
        end

        // Calculate out_any
        for (i = 1; i < WIDTH; i++) begin
            out_any[i] = in[i] | in[i - 1];
        end
        out_any[0] = in[0];

        // Calculate out_different
        for (i = 0; i < WIDTH - 1; i++) begin
            out_different[i] = in[i] ^ in[i + 1];
        end
        // Wrap-around for the most significant bit
        out_different[WIDTH - 1] = in[WIDTH - 1] ^ in[0];
    end

endmodule