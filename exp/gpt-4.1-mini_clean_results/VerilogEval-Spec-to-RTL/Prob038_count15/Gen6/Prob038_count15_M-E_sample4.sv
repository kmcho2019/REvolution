module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_count;
assign next_count = q + 4'b0001;

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else
        q <= next_count;
end

endmodule