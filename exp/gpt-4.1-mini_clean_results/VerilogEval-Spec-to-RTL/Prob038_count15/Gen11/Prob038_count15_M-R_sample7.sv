module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (reset) begin
        next_q = 4'b0000;
    end else begin
        next_q = q + 1;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule