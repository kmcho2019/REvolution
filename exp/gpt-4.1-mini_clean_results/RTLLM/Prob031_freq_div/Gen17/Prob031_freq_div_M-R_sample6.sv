module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counter for 10MHz clock division
    reg [5:0] cnt_100;   // Counter for 1MHz clock division

    // Combined always block for all clock divisions
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50MHz clock toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10MHz clock division (divide by 10)
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1MHz clock division (divide by 100)
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule