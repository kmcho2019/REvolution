module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters: half-period counts for toggling outputs
    parameter HALF_PERIOD_10  = 5 - 1;   // Toggle every 5 clocks => divide by 10
    parameter HALF_PERIOD_100 = 50 - 1;  // Toggle every 50 clocks => divide by 100

    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    // CLK_50: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // CLK_10: toggle every 10 input clocks using a counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == HALF_PERIOD_10) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1: toggle every 100 input clocks using a counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == HALF_PERIOD_100) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule