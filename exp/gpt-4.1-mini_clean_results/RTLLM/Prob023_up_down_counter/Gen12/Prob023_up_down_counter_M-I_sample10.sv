module up_down_counter #(
    parameter WIDTH = 16
)(
    input  wire               clk,
    input  wire               reset,
    input  wire               up_down,
    output reg  [WIDTH-1:0]   count
);

wire [WIDTH-1:0] count_inc;
wire [WIDTH-1:0] count_dec;

assign count_inc = count + {{(WIDTH-1){1'b0}}, 1'b1};  // count + 1
assign count_dec = count - {{(WIDTH-1){1'b0}}, 1'b1};  // count - 1

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else begin
        if (up_down)
            count <= count_inc;
        else
            count <= count_dec;
    end
end

endmodule