module freq_div(
    input           CLK_in,
    input           RST,
    output          CLK_50,
    output          CLK_10,
    output          CLK_1
);

reg             CLK_50_reg;
reg             CLK_10_reg;
reg             CLK_1_reg;
reg [1:0]       cnt_10;
reg [5:0]       cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50_reg <= 1'b0;
        CLK_10_reg <= 1'b0;
        cnt_10     <= 2'b00;
        CLK_1_reg  <= 1'b0;
        cnt_100    <= 6'b000000;
    end else begin
        CLK_50_reg <= ~CLK_50_reg;
        
        cnt_10     <= cnt_10 + 1'b1;
        if (cnt_10 == 4'b0100) begin
            cnt_10     <= 2'b00;
            CLK_10_reg <= ~CLK_10_reg;
        end
        
        cnt_100    <= cnt_100 + 1'b1;
        if (cnt_100 == 6'b110001) begin
            cnt_100    <= 6'b000000;
            CLK_1_reg  <= ~CLK_1_reg;
        end
    end
end

assign CLK_50 = CLK_50_reg;
assign CLK_10 = CLK_10_reg;
assign CLK_1  = CLK_1_reg;

endmodule