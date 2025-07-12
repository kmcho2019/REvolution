module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Count limits for toggling clocks
    localparam CNT_10_MAX  = 3'd4;  // toggle every 5 cycles => divide by 10
    localparam CNT_100_MAX = 6'd49; // toggle every 50 cycles => divide by 100

    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    // CLK_50 generation: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // CLK_10 generation: toggle when counter reaches CNT_10_MAX
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == CNT_10_MAX) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1 generation: toggle when counter reaches CNT_100_MAX
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == CNT_100_MAX) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule