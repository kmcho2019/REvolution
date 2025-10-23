module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for count max values corresponding to toggling points
    localparam CNT_10_MAX  = 3'd4;   // toggle CLK_10 at count 4 (divide by 10)
    localparam CNT_100_MAX = 6'd49;  // toggle CLK_1 at count 49 (divide by 100)

    // Counters for frequency division
    reg [2:0]  cnt_10;    // 3-bit counter for 10MHz clock
    reg [5:0]  cnt_100;   // 6-bit counter for 1MHz clock

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Asynchronous reset: clear all outputs and counters
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50: toggle every clock edge (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 division logic
            if (cnt_10 == CNT_10_MAX) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 division logic
            if (cnt_100 == CNT_100_MAX) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule