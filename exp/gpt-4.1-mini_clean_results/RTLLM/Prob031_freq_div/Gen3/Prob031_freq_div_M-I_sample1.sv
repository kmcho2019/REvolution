module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameterize half counts for toggling outputs
    localparam HALF_DIV_2   = 1;    // For divide by 2 (toggle every 1 clock)
    localparam HALF_DIV_10  = 5;    // For divide by 10 (toggle every 5 clocks)
    localparam HALF_DIV_100 = 50;   // For divide by 100 (toggle every 50 clocks)

    // Counter widths calculated from max counts:
    // For divide by 10: max count = 5 -> 3 bits
    // For divide by 100: max count = 50 -> 6 bits
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    // CLK_50 generation counter for clarity (optional)
    reg cnt_2; // only 1 bit needed for half cycle count

    always @(posedge CLK_in) begin
        if (RST) begin
            // Reset outputs and counters synchronously
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_2   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50 generation: divide by 2
            if (cnt_2 == HALF_DIV_2 - 1) begin
                CLK_50 <= ~CLK_50;
                cnt_2  <= 1'b0;
            end else begin
                cnt_2 <= cnt_2 + 1'b1;
            end

            // CLK_10 generation: divide by 10 (toggle every 5 clocks)
            if (cnt_10 == HALF_DIV_10 - 1) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 generation: divide by 100 (toggle every 50 clocks)
            if (cnt_100 == HALF_DIV_100 - 1) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule