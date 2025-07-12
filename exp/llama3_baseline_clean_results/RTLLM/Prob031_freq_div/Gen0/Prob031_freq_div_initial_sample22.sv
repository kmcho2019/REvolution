module freq_div (
    input         CLK_in,
    input         RST,
    output reg    CLK_50,
    output reg    CLK_10,
    output reg    CLK_1
);

reg [1:0]   cnt_2;
reg [2:0]   cnt_10;
reg [5:0]   cnt_100;

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset CLK_50, CLK_10, and CLK_1
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1  <= 1'b0;
        // Reset counters
        cnt_2  <= 2'd0;
        cnt_10 <= 3'd0;
        cnt_100 <= 6'd0;
    end else begin
        // Toggle CLK_50 on every positive edge of CLK_in
        CLK_50 <= ~CLK_50;
        
        // Generate CLK_10
        if (cnt_10 == 4'd9) begin
            // Toggle CLK_10 and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'd0;
        end else begin
            // Increment counter
            cnt_10 <= cnt_10 + 1'd1;
        end
        
        // Generate CLK_1
        if (cnt_100 == 6'd99) begin
            // Toggle CLK_1 and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'd0;
        end else begin
            // Increment counter
            cnt_100 <= cnt_100 + 1'd1;
        end
    end
end

endmodule