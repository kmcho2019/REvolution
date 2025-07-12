module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt; // 7-bit counter sufficient for divide by 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt    <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment counter modulo 100
            if (cnt == 7'd99)
                cnt <= 7'd0;
            else
                cnt <= cnt + 7'd1;

            // CLK_50: toggle every 1 clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10: toggle when cnt mod 10 == 4 (half of 10 - 1)
            if (cnt % 10 == 7'd4)
                CLK_10 <= ~CLK_10;

            // CLK_1: toggle when cnt == 49 (half of 100 -1)
            if (cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule