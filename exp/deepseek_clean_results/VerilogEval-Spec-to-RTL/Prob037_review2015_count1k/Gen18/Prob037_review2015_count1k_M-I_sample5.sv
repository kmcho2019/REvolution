module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

reg terminal_count;

always @(posedge clk) begin
    terminal_count <= (q == 10'd999);
    
    if (reset) begin
        q <= 10'd0;
    end
    else begin
        q <= terminal_count ? 10'd0 : q + 1'b1;
    end
end

endmodule