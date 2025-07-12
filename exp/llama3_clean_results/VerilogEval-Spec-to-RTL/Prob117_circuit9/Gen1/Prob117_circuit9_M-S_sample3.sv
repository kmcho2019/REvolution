module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 4;
    end else begin
        q <= (q == 7)? 0 : q + 1;
    end
end

endmodule