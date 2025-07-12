module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 1000;

always @(posedge clk) begin
    if(reset) begin
        q <= 0;
    end else if(q == MAX_COUNT - 1) begin
        q <= 0;
    end else begin
        q <= q + 1;
    end
end

endmodule