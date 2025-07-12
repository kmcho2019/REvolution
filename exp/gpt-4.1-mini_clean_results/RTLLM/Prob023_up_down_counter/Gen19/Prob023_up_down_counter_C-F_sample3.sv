module up_down_counter #(
    parameter WIDTH = 16
)(
    input  wire               clk,
    input  wire               reset,
    input  wire               up_down,
    output reg  [WIDTH-1:0]   count
);

wire [WIDTH-1:0] one = {{(WIDTH-1){1'b0}}, 1'b1};
wire [WIDTH-1:0] count_inc = count + one;
wire [WIDTH-1:0] count_dec = count - one;

reg [WIDTH-1:0] next_count;

always @(*) begin
    if (up_down)
        next_count = count_inc;
    else
        next_count = count_dec;
end

always @(posedge clk) begin
    if (reset)
        count <= {WIDTH{1'b0}};
    else
        count <= next_count;
end

endmodule