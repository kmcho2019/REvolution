module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] pedge
);

    reg [WIDTH-1:0] prev_in_reg;

    always @(posedge clk) begin
        prev_in_reg <= in;               // Store previous cycle's input
        pedge <= in & ~prev_in_reg;      // Detect 0->1 transitions
    end

endmodule