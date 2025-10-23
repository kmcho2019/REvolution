module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,        // 0 = AM, 1 = PM
    output reg [7:0] hh,    // BCD hour (01-12)
    output reg [7:0] mm,    // BCD minute (00-59)
    output reg [7:0] ss     // BCD second (00-59)
);

    // Intermediate signals for next state
    reg pm_next;
    reg [3:0] ss_u_next, ss_t_next; // seconds units, tens
    reg [3:0] mm_u_next, mm_t_next; // minutes units, tens
    reg [3:0] hh_u_next, hh_t_next; // hours units, tens

    // Current BCD digits for easier manipulation
    wire [3:0] ss_u = ss[3:0];
    wire [3:0] ss_t = ss[7:4];
    wire [3:0] mm_u = mm[3:0];
    wire [3:0] mm_t = mm[7:4];
    wire [3:0] hh_u = hh[3:0];
    wire [3:0] hh_t = hh[7:4];

    // BCD increment function: increments digit and returns carry if rolled over max_val
    function [4:0] bcd_inc;
        input [3:0] digit;
        input [3:0] max_val;
        begin
            if (digit == max_val)
                bcd_inc = {1'b1, 4'd0}; // carry out, reset digit
            else
                bcd_inc = {1'b0, digit + 1};
        end
    endfunction

    // Hour increment special for 12-hour clock with PM toggle
    task hour_increment(
        input [3:0] cur_tens,
        input [3:0] cur_units,
        input pm_in,
        output [3:0] next_tens,
        output [3:0] next_units,
        output reg next_pm
    );
        integer hour_dec;
        begin
            hour_dec = cur_tens*10 + cur_units;
            if (hour_dec == 11) begin
                // 11 -> 12, toggle PM
                hour_dec = 12;
                next_pm = ~pm_in;
            end else if (hour_dec == 12) begin
                // 12 -> 1, PM unchanged
                hour_dec = 1;
                next_pm = pm_in;
            end else begin
                // Normal increment
                hour_dec = hour_dec + 1;
                next_pm = pm_in;
            end
            next_tens = hour_dec / 10;
            next_units = hour_dec % 10;
        end
    endtask

    // Combinational logic for next state calculation
    always @* begin
        // Defaults: hold current values
        pm_next = pm;
        ss_u_next = ss_u;
        ss_t_next = ss_t;
        mm_u_next = mm_u;
        mm_t_next = mm_t;
        hh_u_next = hh_u;
        hh_t_next = hh_t;

        if (ena) begin
            // Increment seconds units
            reg carry_su, carry_st;
            reg carry_mu, carry_mt;
            reg [3:0] tmp_su, tmp_st;
            reg [3:0] tmp_mu, tmp_mt;
            reg [3:0] tmp_hu, tmp_ht;
            reg tmp_pm;

            {carry_su, tmp_su} = bcd_inc(ss_u, 4'd9);
            tmp_st = ss_t;
            if (carry_su) begin
                {carry_st, tmp_st} = bcd_inc(ss_t, 4'd5);
            end else begin
                carry_st = 0;
            end

            tmp_mu = mm_u;
            tmp_mt = mm_t;
            if (carry_st) begin
                {carry_mu, tmp_mu} = bcd_inc(mm_u, 4'd9);
                if (carry_mu) begin
                    {carry_mt, tmp_mt} = bcd_inc(mm_t, 4'd5);
                end else begin
                    carry_mt = 0;
                end
            end else begin
                carry_mu = 0;
                carry_mt = 0;
            end

            tmp_hu = hh_u;
            tmp_ht = hh_t;
            tmp_pm = pm;
            if (carry_mt) begin
                hour_increment(hh_t, hh_u, pm, tmp_ht, tmp_hu, tmp_pm);
            end

            // Assign next values
            ss_u_next = tmp_su;
            ss_t_next = tmp_st;
            mm_u_next = tmp_mu;
            mm_t_next = tmp_mt;
            hh_u_next = tmp_hu;
            hh_t_next = tmp_ht;
            pm_next = tmp_pm;
        end
    end

    // Sequential logic with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 12:00:00 AM
            pm <= 1'b0;
            hh <= 8'h12;  // 0x12 = BCD 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else begin
            pm <= pm_next;
            hh <= {hh_t_next, hh_u_next};
            mm <= {mm_t_next, mm_u_next};
            ss <= {ss_t_next, ss_u_next};
        end
    end

endmodule