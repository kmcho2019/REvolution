module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Intermediate next state signals
    reg pm_next;
    reg [7:0] hh_next;
    reg [7:0] mm_next;
    reg [7:0] ss_next;

    // Function: BCD increment with max limit; returns {carry_out, new_digit}
    function [4:0] bcd_inc;
        input [3:0] digit;
        input [3:0] max_val;
        begin
            if (digit == max_val)
                bcd_inc = {1'b1, 4'd0};
            else
                bcd_inc = {1'b0, digit + 1};
        end
    endfunction

    // Combinational block: compute next values based on current values and ena
    always @* begin
        // Default next values same as current
        pm_next = pm;
        hh_next = hh;
        mm_next = mm;
        ss_next = ss;

        if (ena) begin
            // Increment seconds units
            reg [4:0] sec_u;
            reg [4:0] sec_t;
            reg [4:0] min_u;
            reg [4:0] min_t;
            reg [4:0] hour_u;
            reg [4:0] hour_t;

            sec_u = bcd_inc(ss[3:0], 4'd9);
            sec_t = ss[7:4];
            min_u = mm[3:0];
            min_t = mm[7:4];
            hour_u = hh[3:0];
            hour_t = hh[7:4];

            if (sec_u[4]) begin
                // seconds units rolled over
                sec_u = 5'd0;
                sec_t = bcd_inc(sec_t, 4'd5);
                if (sec_t[4]) begin
                    // seconds tens rolled over
                    sec_t = 5'd0;
                    // increment minutes units
                    min_u = bcd_inc(min_u, 4'd9);
                    if (min_u[4]) begin
                        min_u = 5'd0;
                        // increment minutes tens
                        min_t = bcd_inc(min_t, 4'd5);
                        if (min_t[4]) begin
                            // minutes tens rolled over
                            min_t = 5'd0;
                            // increment hour with 12-hour special logic
                            // Convert hour BCD to integer
                            integer h_dec;
                            h_dec = hour_t * 10 + hour_u;
                            if (h_dec == 11) begin
                                // 11 -> 12 toggles pm
                                h_dec = 12;
                                pm_next = ~pm_next;
                            end else if (h_dec == 12) begin
                                // 12 -> 1 no pm toggle
                                h_dec = 1;
                            end else begin
                                h_dec = h_dec + 1;
                            end
                            hour_t = h_dec / 10;
                            hour_u = h_dec % 10;
                        end
                    end
                end
            end

            // Compose next BCD values
            ss_next = {sec_t[3:0], sec_u[3:0]};
            mm_next = {min_t[3:0], min_u[3:0]};
            hh_next = {hour_t[3:0], hour_u[3:0]};
        end
    end

    // Sequential update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;      // AM
            hh <= 8'h12;     // 12 in BCD
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            pm <= pm_next;
            hh <= hh_next;
            mm <= mm_next;
            ss <= ss_next;
        end
    end

endmodule