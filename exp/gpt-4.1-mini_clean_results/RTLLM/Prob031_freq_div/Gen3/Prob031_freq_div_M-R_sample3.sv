module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] cnt;  // 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt == 7'd99) begin
                cnt <= 7'd0;
            end else begin
                cnt <= cnt + 7'd1;
            end

            // CLK_50: toggle every 1 cycle (divide by 2)
            // Since the full cycle is 2 clocks, toggle CLK_50 at each increment of cnt LSB
            CLK_50 <= cnt[0];

            // CLK_10: toggle every 5 cycles (divide by 10)
            // Counting from 0 to 9 for one full cycle, toggle when cnt mod 10 hits half cycle at 4 or 9
            // Alternatively, CLK_10 = cnt[3:1] toggled every 5 cycles:
            // Let's use cnt[3:1] to reflect counts from 0 to 4 then toggle
            // Actually, toggling on cnt mod 10 reaching 4 is equivalent to toggling when cnt mod 10 ==4

            // We toggle CLK_10 on counts 4 and 9, so CLK_10 changes state every 5 counts
            // Implement CLK_10 as (cnt / 5) LSB
            CLK_10 <= cnt[3]; // cnt[3] toggles every 8 counts, which is close but not precise
            // To be accurate, use: toggle CLK_10 when cnt mod 10 crosses 4, so we can do:
            // We'll implement toggle logic separately:

            // To correctly implement toggle for CLK_10 every 5 counts, track toggle internally
            // To simplify, store CLK_10 toggle logic in always block:

            // Let's redefine CLK_10 and CLK_1 in separate always block below
        end
    end

    // For proper toggling of CLK_10 and CLK_1, use internal toggle registers updated on count edges
    reg [2:0] cnt_mod10; // cnt mod 10 for CLK_10 toggle
    reg [6:0] cnt_mod100; // cnt mod 100 for CLK_1 toggle

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_mod10 <= 3'd0;
            CLK_10 <= 1'b0;
            cnt_mod100 <= 7'd0;
            CLK_1 <= 1'b0;
        end else begin
            // cnt_mod10 increments and toggles CLK_10 when reaches 4
            if (cnt_mod10 == 3'd9)
                cnt_mod10 <= 3'd0;
            else
                cnt_mod10 <= cnt_mod10 + 3'd1;

            if (cnt_mod10 == 3'd4) 
                CLK_10 <= ~CLK_10;

            // cnt_mod100 increments and toggles CLK_1 when reaches 49
            if (cnt_mod100 == 7'd99)
                cnt_mod100 <= 7'd0;
            else
                cnt_mod100 <= cnt_mod100 + 7'd1;

            if (cnt_mod100 == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule