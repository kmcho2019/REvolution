module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] next_q;

always @(*) begin
    if (reset) begin
        next_q = 8'h34;
    end else begin
        next_q = d;
    end
end

always @(negedge clk) begin
    q <= next_q;
end

endmodule