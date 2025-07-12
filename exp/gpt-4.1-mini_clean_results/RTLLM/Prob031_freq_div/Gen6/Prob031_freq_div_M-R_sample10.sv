module freq_div (
    input  wire CLK_in,  // 100 MHz input clock
    input  wire RST,     // Asynchronous active-high reset
    output reg  CLK_50,  // 50 MHz output clock (divide by 2)
    output reg  CLK_10,  // 10 MHz output clock (divide by 10)
    output reg  CLK_1    // 1 MHz output clock (divide by 100)
);

    // Counter for 50 MHz (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Counter and toggling for 10 MHz (divide by 10)
    reg [2:0] cnt_10;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
        end
    end

    // Counter and toggling for 1 MHz (divide by 100)
    reg [5:0] cnt_100;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
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