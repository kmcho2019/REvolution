module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] main_cnt; // Counts from 0 to 99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_cnt <= 7'd0;
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
        end else begin
            // Increment and wrap counter at 100
            if (main_cnt == 7'd99)
                main_cnt <= 7'd0;
            else
                main_cnt <= main_cnt + 7'd1;

            // CLK_50 toggles every 1 cycle => toggle at every count (like divide by 2)
            // Because we want 50MHz from 100MHz input, toggle every 1 input cycle
            // So toggle CLK_50 on every count equals toggling every clock cycle
            CLK_50 <= ~CLK_50;

            // CLK_10 toggles every 5 cycles (since toggling doubles period)
            // That corresponds to toggling on counts 4,9,14,... but simpler is toggle at count==4, 9,14,... 
            // Using the counter's modulus 10 property: toggle CLK_10 when (main_cnt % 10) == 4
            if ((main_cnt % 10) == 4)
                CLK_10 <= ~CLK_10;

            // CLK_1 toggles every 50 cycles (counts 49, 99)
            // Toggle when main_cnt == 49 or 99
            if ((main_cnt == 7'd49) || (main_cnt == 7'd99))
                CLK_1 <= ~CLK_1;
        end
    end

endmodule