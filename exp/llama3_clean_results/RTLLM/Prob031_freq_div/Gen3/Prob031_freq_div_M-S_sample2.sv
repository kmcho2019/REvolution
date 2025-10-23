module freq_div (
    input          CLK_in,  // Input clock signal
    input          RST,     // Reset signal
    output         CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output         CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output         CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg     CLK_50_reg;
reg     CLK_10_reg;
reg     CLK_1_reg;
reg [1:0]  cnt_2;  // Counter for CLK_50
reg [3:0]  cnt_10;  // Counter for CLK_10
reg [6:0]  cnt_100;  // Counter for CLK_1

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Synchronous reset: Reset all the counters and output clocks on the positive edge of CLK_in or RST
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        cnt_2 <= 2'd0;
        CLK_1_reg <= 1'b0;
        cnt_10 <= 4'd0;
        cnt_100 <= 7'd0;
    end else begin
        // Toggle CLK_50 on every other positive edge of CLK_in
        if (cnt_2 == 2'd1) begin
            CLK_50_reg <= ~CLK_50_reg;
            cnt_2 <= 2'd0;
        end else begin
            cnt_2 <= cnt_2 + 1'b1;
        end
        
        // Toggle CLK_10 when cnt_10 reaches 4
        if (cnt_10 == 4'd9) begin
            CLK_10_reg <= ~CLK_10_reg;
            cnt_10 <= 4'd0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // Toggle CLK_1 when cnt_100 reaches 49
        if (cnt_100 == 7'd49) begin
            CLK_1_reg <= ~CLK_1_reg;
            cnt_100 <= 7'd0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule