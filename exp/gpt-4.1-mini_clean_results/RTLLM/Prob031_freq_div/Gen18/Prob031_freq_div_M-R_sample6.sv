module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Define half period counts for toggling clocks (divide by 2N)
    `define HALF_PERIOD_10  4   // toggle every 5 cycles (0..4)
    `define HALF_PERIOD_100 49  // toggle every 50 cycles (0..49)

    reg [2:0]  cnt_10;
    reg [5:0]  cnt_100;

    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50: toggle every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation: toggle when counter reaches HALF_PERIOD_10
            if (cnt_10 == `HALF_PERIOD_10) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 generation: toggle when counter reaches HALF_PERIOD_100
            if (cnt_100 == `HALF_PERIOD_100) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule