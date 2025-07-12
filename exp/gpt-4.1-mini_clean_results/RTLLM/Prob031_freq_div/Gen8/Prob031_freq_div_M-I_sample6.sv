module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Define count limits for clarity and easy modification
    localparam CNT_10_MAX  = 3'd4;   // toggle CLK_10 every 5 cycles (divide by 10)
    localparam CNT_100_MAX = 6'd49;  // toggle CLK_1 every 50 cycles (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;    // 3 bits sufficient for count to 4
    reg [5:0]  cnt_100;   // 6 bits sufficient for count to 49

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // Toggle CLK_50 every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 counter and toggle with clock enable style to reduce toggling
            if (cnt_10 == CNT_10_MAX) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
                // CLK_10 unchanged to reduce toggling
            end

            // CLK_1 counter and toggle with clock enable style to reduce toggling
            if (cnt_100 == CNT_100_MAX) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
                // CLK_1 unchanged to reduce toggling
            end
        end
    end

endmodule