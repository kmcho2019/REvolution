module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Increment a BCD digit with given max limit; returns incremented digit and carry out
    function [4:0] bcd_inc;
        input [3:0] digit;
        input [3:0] max_val;
        reg [4:0] result;
        begin
            if (digit == max_val)
                result = {1'b1, 4'd0}; // carry out 1, digit reset to 0
            else
                result = {1'b0, digit + 1};
            bcd_inc = result;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            pm <= 0;
            hh <= 8'h12; // 12 in BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            // Increment seconds units
            reg [4:0] sec_u;
            reg [4:0] sec_t;
            reg [4:0] min_u;
            reg [4:0] min_t;
            reg [4:0] hour_u;
            reg [4:0] hour_t;
            reg pm_next;

            sec_u = bcd_inc(ss[3:0], 4'd9);
            sec_t = ss[7:4];
            min_u = mm[3:0];
            min_t = mm[7:4];
            hour_u = hh[3:0];
            hour_t = hh[7:4];
            pm_next = pm;

            if (sec_u[4]) begin
                // Seconds units wrapped
                sec_u = 5'd0;
                sec_t = bcd_inc(ss[7:4], 4'd5);
                if (sec_t[4]) begin
                    // Seconds tens wrapped
                    sec_t = 5'd0;
                    // Increment minutes units
                    min_u = bcd_inc(mm[3:0], 4'd9);
                    if (min_u[4]) begin
                        min_u = 5'd0;
                        // Increment minutes tens
                        min_t = bcd_inc(mm[7:4], 4'd5);
                        if (min_t[4]) begin
                            // Minutes tens wrapped
                            min_t = 5'd0;
                            // Increment hours - special 12-hour logic
                            // Hours range from 01 to 12 in BCD
                            // We'll convert hh to integer (1 to 12), increment, wrap at 12 to 1
                            integer h_dec;
                            h_dec = hour_t * 10 + hour_u;
                            if (h_dec == 11) begin
                                // 11 -> 12
                                h_dec = 12;
                                pm_next = ~pm_next; // toggle am/pm on 11->12
                            end else if (h_dec == 12) begin
                                // 12 -> 1
                                h_dec = 1;
                            end else begin
                                h_dec = h_dec + 1;
                            end
                            // Convert back to BCD
                            hour_t = h_dec / 10;
                            hour_u = h_dec % 10;
                        end
                    end
                end
            end

            // Assign updated values back to outputs
            ss <= {sec_t[3:0], sec_u[3:0]};
            mm <= {min_t[3:0], min_u[3:0]};
            hh <= {hour_t[3:0], hour_u[3:0]};
            pm <= pm_next;
        end
    end

endmodule