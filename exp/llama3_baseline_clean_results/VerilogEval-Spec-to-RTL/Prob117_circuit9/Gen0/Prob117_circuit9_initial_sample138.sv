module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a == 1'b0) begin
        if (q == 3'b111) begin // 7 in decimal
            q <= 3'b000; // wrap around to 0
        end else begin
            q <= q + 1'b1;
        end
    end
end

initial begin
    q = 3'b100; // initial value of q is 4
end

endmodule