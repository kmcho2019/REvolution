module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared counter for both 10MHz and 1MHz clocks (counts 0-99)
    reg [6:0] cnt;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Shared counter and clock generation
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt <= 7'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt == 7'd99) begin
                cnt <= 7'b0;
            end else begin
                cnt <= cnt + 1'b1;
            end

            // CLK_10 toggles every 5 cycles (bit 4 changes every 5 counts)
            if (cnt[4:0] == 5'b00100) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 toggles every 50 cycles (bit 6 changes every 50 counts)
            if (cnt == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule