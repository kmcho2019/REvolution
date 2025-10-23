module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter for divide-by-10 clock: toggle every 5 input clocks
    reg [2:0] cnt_10;

    // Counter for divide-by-100 clock: toggle every 50 input clocks
    reg [5:0] cnt_100;

    // CLK_50: divide by 2 - toggle every rising edge of CLK_in
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // CLK_10: divide by 10
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == 3'd4) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1: divide by 100
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule