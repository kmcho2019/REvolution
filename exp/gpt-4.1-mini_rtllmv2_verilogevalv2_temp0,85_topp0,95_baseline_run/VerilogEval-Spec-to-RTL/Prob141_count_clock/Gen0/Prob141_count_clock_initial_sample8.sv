module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // BCD increment function for 2-digit BCD (0-59 for mm and ss)
    function [7:0] bcd_increment_59;
        input [7:0] bcd_in;
        reg [3:0] ones, tens;
        begin
            ones = bcd_in[3:0];
            tens = bcd_in[7:4];
            if (ones == 4'd9) begin
                ones = 4'd0;
                if (tens == 4'd5)
                    tens = 4'd0;
                else
                    tens = tens + 4'd1;
            end else begin
                ones = ones + 4'd1;
            end
            bcd_increment_59 = {tens, ones};
        end
    endfunction

    // BCD increment function for hours (01-12)
    // Inputs: current hh BCD
    // Output: incremented hh BCD and flag rollover (1 if hour wrapped from 12 to 1)
    function [8:0] bcd_increment_12;
        input [7:0] bcd_in;
        reg [3:0] ones, tens;
        reg rollover;
        reg [7:0] next_hh;
        begin
            ones = bcd_in[3:0];
            tens = bcd_in[7:4];
            rollover = 0;

            // Increment hour by 1
            if (bcd_in == 8'h12) begin
                // 12 -> 1
                next_hh = 8'h01;
                rollover = 1;
            end else if (ones == 4'd9) begin
                // carry ones digit
                ones = 4'd0;
                tens = tens + 4'd1;
                next_hh = {tens, ones};
            end else begin
                ones = ones + 4'd1;
                next_hh = {tens, ones};
            end

            bcd_increment_12 = {rollover, next_hh};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            hh <= 8'h12;
            mm <= 8'h00;
            ss <= 8'h00;
            pm <= 1'b0;
        end else if (ena) begin
            // Increment seconds
            if (ss == 8'h59) begin
                ss <= 8'h00;
                // Increment minutes
                if (mm == 8'h59) begin
                    mm <= 8'h00;
                    // Increment hours
                    reg rollover_hour;
                    reg [7:0] next_hour;
                    {rollover_hour, next_hour} = bcd_increment_12(hh);
                    hh <= next_hour;
                    if (rollover_hour)
                        pm <= ~pm; // toggle am/pm at 12:00
                end else begin
                    mm <= bcd_increment_59(mm);
                end
            end else begin
                ss <= bcd_increment_59(ss);
            end
        end
    end

endmodule