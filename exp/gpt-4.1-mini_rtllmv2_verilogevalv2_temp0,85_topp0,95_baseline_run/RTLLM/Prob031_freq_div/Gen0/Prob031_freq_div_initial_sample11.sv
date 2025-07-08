module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counter for 10 MHz clock (counts 0 to 4)
    reg [5:0] cnt_100;   // Counter for 1 MHz clock (counts 0 to 49)

    // CLK_50 generation: toggle every clk rising edge
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: toggle every 5 counts (counts 0 to 4)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
        end
    end

    // CLK_1 generation: toggle every 50 counts (counts 0 to 49)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else begin
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule