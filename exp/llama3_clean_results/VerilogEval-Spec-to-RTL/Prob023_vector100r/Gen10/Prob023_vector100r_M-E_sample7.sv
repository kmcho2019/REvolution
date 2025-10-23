module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    always @(*) begin
        for (int i = 0; i < WIDTH; i++) begin
            out[i] = in[WIDTH - 1 - i];
        end
    end

endmodule