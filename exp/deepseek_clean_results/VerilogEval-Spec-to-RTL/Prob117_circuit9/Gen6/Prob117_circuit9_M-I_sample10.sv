module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        next_q = (q == 3'd6) ? 3'd0 : q + 1'b1;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule