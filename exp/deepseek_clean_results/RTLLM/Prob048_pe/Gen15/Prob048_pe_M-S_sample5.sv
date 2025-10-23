module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c
);

    always @(posedge clk) begin
        if (rst) begin
            c <= 0;  // Reset to zero
        end else begin
            c <= c + (a * b);  // Direct multiply-accumulate
        end
    end

endmodule