module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);
    always @(*) begin
        for (int i = 0; i < WIDTH; i = i + 1) begin
            out[i] = in[WIDTH-1-i];
        end
    end
endmodule