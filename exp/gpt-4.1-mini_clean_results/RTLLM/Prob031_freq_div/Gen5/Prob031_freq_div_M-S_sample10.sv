module freq_div (
    input  wire CLK_in,  // 100 MHz input clock
    input  wire RST,     // Synchronous active-high reset
    output reg  CLK_50,  // 50 MHz output clock (divide by 2)
    output reg  CLK_10,  // 10 MHz output clock (divide by 10)
    output reg  CLK_1    // 1 MHz output clock (divide by 100)
);

    reg [2:0] cnt_10;    // counts 0 to 4 for 10 MHz toggle
    reg [5:0] cnt_100;   // counts 0 to 49 for 1 MHz toggle

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
            cnt_10 <= 3'd0;
            cnt_100<= 6'd0;
        end else begin
            // Toggle 50 MHz clock every cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10 MHz clock: toggle when cnt_10 reaches 4
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end

            // 1 MHz clock: toggle when cnt_100 reaches 49
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end

endmodule