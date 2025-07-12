module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if(a == 0) begin
        q <= (q + 1) % 8;
    end
end

endmodule