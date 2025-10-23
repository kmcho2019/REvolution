module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire cen = ~reset;  // clock enable active when not in reset

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (q == 4'd9) begin
        q <= 4'd0;
    end else if (cen) begin
        q <= q + 4'd1;
    end
end

endmodule