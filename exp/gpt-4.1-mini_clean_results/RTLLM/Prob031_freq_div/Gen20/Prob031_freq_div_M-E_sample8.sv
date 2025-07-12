module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counters for each clock domain
    reg [0:0] cnt_2;      // Count up to 2 (for CLK_50)
    reg [3:0] cnt_10;     // Count up to 10 (for CLK_10)
    reg [6:0] cnt_100;    // Count up to 100 (for CLK_1)

    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_2   <= 0;
            cnt_10  <= 0;
            cnt_100 <= 0;
            CLK_50  <= 0;
            CLK_10  <= 0;
            CLK_1   <= 0;
        end else begin
            // CLK_50: divide by 2, toggle every 1 count (half of 2)
            if (cnt_2 == 1) begin
                cnt_2 <= 0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_2 <= cnt_2 + 1;
            end

            // CLK_10: divide by 10, toggle every 5 counts (half of 10)
            if (cnt_10 == 9) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // CLK_1: divide by 100, toggle every 50 counts (half of 100)
            if (cnt_100 == 99) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule