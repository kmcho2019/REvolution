module up_down_counter #(
    parameter WIDTH = 16
)(
    input  wire               clk,
    input  wire               reset,
    input  wire               up_down,
    output reg  [WIDTH-1:0]   count
);

wire [WIDTH-1:0] count_inc = count + {{(WIDTH-1){1'b0}}, 1'b1};
wire [WIDTH-1:0] count_dec = count - {{(WIDTH-1){1'b0}}, 1'b1};

always @(posedge clk) begin
    if (reset)
        count <= {WIDTH{1'b0}};
    else
        count <= up_down ? count_inc : count_dec;
end

endmodule