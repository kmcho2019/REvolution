module freq_div (
    input  CLK_in,  // Input clock signal
    input  RST,     // Reset signal
    output CLK_50,  // Output clock signal with a frequency of CLK_in divided by 2
    output CLK_10,  // Output clock signal with a frequency of CLK_in divided by 10
    output CLK_1    // Output clock signal with a frequency of CLK_in divided by 100
);

reg CLK_50_reg;
reg CLK_10_reg;
reg CLK_1_reg;
reg [1:0] cnt_2;
reg [3:0] cnt_10;
reg [5:0] cnt_100;

always @ (posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        CLK_1_reg <= 1'b0;
        cnt_2 <= 2'b00;
        cnt_10 <= 4'b0000;
        cnt_100 <= 6'b000000;
    end else begin
        // Generation of CLK_50
        CLK_50_reg <= ~CLK_50_reg;

        // Generation of CLK_10
        cnt_10 <= cnt_10 + 1'b1;
        if (cnt_10 == 4'd9) begin
            CLK_10_reg <= ~CLK_10_reg;
            cnt_10 <= 4'b0000;
        end

        // Generation of CLK_1
        cnt_100 <= cnt_100 + 1'b1;
        if (cnt_100 == 6'd99) begin
            CLK_1_reg <= ~CLK_1_reg;
            cnt_100 <= 6'b000000;
        end
    end
end

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1 = CLK_1_reg;

endmodule