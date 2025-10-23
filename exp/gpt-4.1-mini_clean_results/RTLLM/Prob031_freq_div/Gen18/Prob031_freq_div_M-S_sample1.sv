module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for toggle counts (half periods)
    localparam CNT_10_MAX  = 4;   // Toggle CLK_10 at count 4 (counts 0 to 4)
    localparam CNT_100_MAX = 49;  // Toggle CLK_1 at count 49 (counts 0 to 49)

    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            CLK_50 <= ~CLK_50; // Toggle every cycle (divide by 2)

            // Counter and toggle for 10MHz (divide by 10)
            if (cnt_10 == CNT_10_MAX) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // Counter and toggle for 1MHz (divide by 100)
            if (cnt_100 == CNT_100_MAX) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule