module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

parameter MAX_COUNT = 999;  // Synthesis-friendly parameter
reg is_max;

always @(posedge clk) begin
    is_max <= (q == MAX_COUNT);
    
    if (reset) begin
        q <= 10'b0;
    end else begin
        q <= is_max ? 10'b0 : q + 1'b1;
    end
end

endmodule