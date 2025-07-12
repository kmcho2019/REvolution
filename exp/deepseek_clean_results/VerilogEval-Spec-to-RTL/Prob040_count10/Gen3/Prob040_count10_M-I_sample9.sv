module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;
wire count_enable = ~terminal_count;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
        terminal_count <= 1'b0;
    end
    else begin
        terminal_count <= (q == 4'd9);
        
        if (count_enable) begin
            q <= q + 1'b1;
        end
        else begin
            q <= 4'b0000;
        end
    end
end

endmodule