module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q = q + 1'b1;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        q <= next_q;
    end
end

endmodule