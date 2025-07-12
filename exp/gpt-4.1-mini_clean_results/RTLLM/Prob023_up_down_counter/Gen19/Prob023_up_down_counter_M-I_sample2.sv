module up_down_counter #(
    parameter WIDTH = 16
)(
    input  wire               clk,
    input  wire               reset,
    input  wire               up_down,
    output reg  [WIDTH-1:0]   count
);

always @(posedge clk) begin
    if (reset)
        count <= {WIDTH{1'b0}};
    else
        count <= count + (up_down ? 1 : -1);
end

endmodule