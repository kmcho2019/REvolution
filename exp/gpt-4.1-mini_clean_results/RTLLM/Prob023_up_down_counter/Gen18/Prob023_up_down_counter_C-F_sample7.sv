module up_down_counter #(
    parameter WIDTH = 16
)(
    input  wire                 clk,
    input  wire                 reset,
    input  wire                 up_down,
    output reg  [WIDTH-1:0]    count
);

wire signed [WIDTH:0] signed_increment = up_down ? 1 : -1;
wire [WIDTH-1:0] next_count = count + signed_increment[WIDTH-1:0];

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else begin
        count <= next_count;
    end
end

endmodule