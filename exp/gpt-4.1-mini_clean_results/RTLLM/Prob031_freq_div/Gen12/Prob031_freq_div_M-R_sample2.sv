module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // 3-bit counter for divide by 10
    reg [5:0] cnt_100;   // 6-bit counter for divide by 100

    // 50MHz clock: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // 10MHz clock generation: divide by 10 using counter and toggle flip-flop
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10  <= 3'd0;
            CLK_10  <= 1'b0;
        end else if (cnt_10 == 3'd4) begin
            cnt_10  <= 3'd0;
            CLK_10  <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // 1MHz clock generation: divide by 100 using counter and toggle flip-flop
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1   <= 1'b0;
        end else if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1   <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule