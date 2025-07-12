module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Parameters for division counts (half period counts)
    parameter DIV_10_HALF = 5 - 1;    // For 10MHz from 100MHz: toggle every 5 cycles minus 1 = 4
    parameter DIV_100_HALF = 50 - 1;  // For 1MHz from 100MHz: toggle every 50 cycles minus 1 = 49

    reg [2:0] cnt_10;     // 3-bit counter for divide by 10
    reg [5:0] cnt_100;    // 6-bit counter for divide by 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all counters and output clocks
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50MHz clock: toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10MHz clock division
            if (cnt_10 == DIV_10_HALF) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1MHz clock division
            if (cnt_100 == DIV_100_HALF) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule