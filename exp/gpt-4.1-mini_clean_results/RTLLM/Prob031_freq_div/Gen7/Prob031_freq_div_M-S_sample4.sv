module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100<= 6'd0;
        end else begin
            // CLK_50 toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 toggle every 5 cycles (divide by 10)
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else
                cnt_10 <= cnt_10 + 1'b1;

            // CLK_1 toggle every 50 cycles (divide by 100)
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else
                cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule