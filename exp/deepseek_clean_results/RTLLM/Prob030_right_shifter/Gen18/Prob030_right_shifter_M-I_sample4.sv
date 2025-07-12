module right_shifter #(
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset_n,    // Active-low synchronous reset
    input wire enable,     // Clock gating enable
    input wire d,
    output reg [WIDTH-1:0] q
);

always @(posedge clk) begin
    if (!reset_n) begin
        q <= {WIDTH{1'b0}};
    end
    else if (enable) begin
        q <= {d, q[WIDTH-1:1]};  // Efficient shift with concatenation
    end
end

endmodule