module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (slowena) begin
        next_q = (q[3] & q[0]) ? 4'b0000 : q + 1'b1;
    end else begin
        next_q = q;
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else begin
        q <= next_q;
    end
end

endmodule