module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= {WIDTH{1'b0}};
    else
        count <= up_down ? count + 1'b1 : count - 1'b1;
end

endmodule