module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire terminal_count;
reg terminal_count_reg;

// Optimized terminal count detection (999 = 1111100111)
// Only need to check bits that are 1 (9,8,7,6,5,2,1,0) and verify bit 4 is 0
assign terminal_count = &q[9:5] & ~q[4] & &q[2:0];

always @(posedge clk) begin
    terminal_count_reg <= terminal_count;
    
    if (reset) begin
        q <= 10'b0;
    end
    else begin
        if (terminal_count_reg) begin
            q <= 10'b0;
        end
        else begin
            q <= q + 1'b1;
        end
    end
end

endmodule