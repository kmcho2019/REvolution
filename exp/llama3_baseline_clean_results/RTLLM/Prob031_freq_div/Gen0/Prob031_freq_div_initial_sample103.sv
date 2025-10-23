module freq_div(
    input  wire  CLK_in,
    input  wire  RST,
    output reg   CLK_50,
    output reg   CLK_10,
    output reg   CLK_1
);

reg [1:0]  cnt_10;
reg [5:0]  cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50  <= 1'b0;
        CLK_10  <= 1'b0;
        CLK_1   <= 1'b0;
        cnt_10  <= 2'b00;
        cnt_100 <= 6'b000000;
    end else begin
        // Generate CLK_50 by toggling its current value
        CLK_50  <= ~CLK_50;
        
        // Generate CLK_10 by counting 5 cycles of CLK_in
        if (cnt_10 == 4) begin
            CLK_10  <= ~CLK_10;
            cnt_10  <= 2'b00;
        end else begin
            cnt_10  <= cnt_10 + 1'b1;
        end
        
        // Generate CLK_1 by counting 50 cycles of CLK_in
        if (cnt_100 == 6'd49) begin
            CLK_1   <= ~CLK_1;
            cnt_100 <= 6'b000000;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule