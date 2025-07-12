module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [6:0] main_cnt; // 7 bits to count 0..99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            // Increment main counter and wrap at 99
            if (main_cnt == 7'd99) begin
                main_cnt <= 7'd0;
            end else begin
                main_cnt <= main_cnt + 7'd1;
            end

            // CLK_50 toggles every clock (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles at counts 4, 14, 24, ... i.e. main_cnt mod 10 == 4
            if (main_cnt[3:0] == 4'd4) begin
                CLK_10 <= ~CLK_10;
            end

            // CLK_1 toggles at count 49 (half period of divide by 100)
            if (main_cnt == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule