module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0]  cnt_10;    // Counter for divide by 10 (toggle every 5 cycles)
    reg [5:0]  cnt_100;   // Counter for divide by 100 (toggle every 50 cycles)

    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // CLK_50 toggles every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 divides by 10: toggle every 5 input clocks
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 divides by 100: toggle every 50 input clocks
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule