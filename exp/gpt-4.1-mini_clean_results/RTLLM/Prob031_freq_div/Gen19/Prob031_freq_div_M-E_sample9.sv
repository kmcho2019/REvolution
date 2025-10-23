module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] main_cnt;  // Counts from 0 to 99 (7 bits)

    // On each clock cycle, increment main counter or reset
    always @(posedge CLK_in) begin
        if (RST) begin
            main_cnt <= 7'd0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (main_cnt == 7'd99)
                main_cnt <= 7'd0;
            else
                main_cnt <= main_cnt + 7'd1;

            // Toggle CLK_50 every 1 count (every cycle)
            if (main_cnt == 7'd0) 
                CLK_50 <= ~CLK_50;

            // Toggle CLK_10 every 5 counts: counts 0,5,10,15,...
            if ((main_cnt % 7'd10) == 7'd0) 
                CLK_10 <= ~CLK_10;

            // Toggle CLK_1 every 50 counts: at count 0 and 50
            if ((main_cnt == 7'd0) || (main_cnt == 7'd50))
                CLK_1 <= ~CLK_1;
        end
    end

endmodule