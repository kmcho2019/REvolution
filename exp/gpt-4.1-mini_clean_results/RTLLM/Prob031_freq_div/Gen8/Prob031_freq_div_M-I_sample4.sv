module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [5:0] cnt;  // 6-bit counter to count from 0 to 49

    // CLK_50 generation: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // Combined counter and CLK_10, CLK_1 generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt <= 6'd0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else if (cnt == 6'd49) begin
            cnt <= 6'd0;
            CLK_1 <= ~CLK_1;           // Toggle CLK_1 every 50 cycles
            // Also toggle CLK_10 since 50 is multiple of 5, at count 49 it corresponds to 10 toggles of CLK_10
            // But CLK_10 toggles every 5 cycles, so toggle at cnt == 4, 9, ..., 49. So also toggle here at 49.
            CLK_10 <= ~CLK_10;
        end else begin
            // Toggle CLK_10 every 5 cycles: at counts 4, 9, 14, 19, 24, 29, 34, 39, 44, 49
            if (cnt % 5 == 4)
                CLK_10 <= ~CLK_10;

            cnt <= cnt + 1'b1;
        end
    end

endmodule