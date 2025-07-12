module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Using a simple for loop to reverse the bits
    always @(*) begin
        for (int i = 0; i < WIDTH; i++) begin
            out[WIDTH - 1 - i] = in[i];
        end
    end

endmodule