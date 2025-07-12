module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] main_cnt; // Counts from 0 to 99 for divide by 100

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_cnt <= 7'd0;
            CLK_1    <= 1'b0;
            CLK_10   <= 1'b0;
            CLK_50   <= 1'b0;
        end else begin
            // Increment main counter, wrap at 99
            if (main_cnt == 7'd99)
                main_cnt <= 7'd0;
            else
                main_cnt <= main_cnt + 7'd1;

            // CLK_50: toggle every clock cycle -> divide by 2
            CLK_50 <= ~CLK_50;

            // CLK_10: toggle when main_cnt mod 10 == 4 (half period)
            if (main_cnt[3:0] == 4'd4) 
                CLK_10 <= ~CLK_10;

            // CLK_1: toggle when main_cnt == 49 (half period of 100 cycles)
            if (main_cnt == 7'd49)
                CLK_1 <= ~CLK_1;
        end
    end

endmodule