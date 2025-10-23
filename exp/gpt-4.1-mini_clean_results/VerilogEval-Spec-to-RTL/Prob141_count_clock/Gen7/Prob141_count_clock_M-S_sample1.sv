module TopModule (
    input        clk,
    input        reset,
    input        ena,
    output reg   pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    // Function to increment BCD from 0 to 9 with wrap
    function [3:0] inc_bcd_digit;
        input [3:0] digit;
        begin
            inc_bcd_digit = (digit == 4'd9) ? 4'd0 : digit + 4'd1;
        end
    endfunction

    // Increment seconds BCD (00-59)
    wire [3:0] ss_ones_next = inc_bcd_digit(ss[3:0]);
    wire       ss_ones_roll = (ss[3:0] == 4'd9);
    wire [3:0] ss_tens_next = (ss_ones_roll) ? inc_bcd_digit(ss[7:4]) : ss[7:4];
    wire       ss_tens_roll = (ss_ones_roll && (ss[7:4] == 4'd5));
    wire       ss_roll = ss_ones_roll && ss_tens_roll;

    wire [7:0] next_ss = ss_roll ? 8'h00 : {ss_tens_next, ss_ones_next};

    // Increment minutes BCD (00-59) on seconds rollover
    wire [3:0] mm_ones_next = inc_bcd_digit(mm[3:0]);
    wire       mm_ones_roll = (mm[3:0] == 4'd9);
    wire [3:0] mm_tens_next = (mm_ones_roll) ? inc_bcd_digit(mm[7:4]) : mm[7:4];
    wire       mm_tens_roll = (mm_ones_roll && (mm[7:4] == 4'd5));
    wire       mm_roll = mm_ones_roll && mm_tens_roll;

    wire [7:0] next_mm = mm_roll ? 8'h00 : {mm_tens_next, mm_ones_next};

    // Increment hours BCD (01-12) on minutes rollover
    // Hours go from 1 to 12 in BCD
    reg [7:0] next_hh;
    reg       next_pm;

    always @* begin
        next_hh = hh;
        next_pm = pm;

        if (mm_roll && ss_roll && ena) begin
            if (hh == 8'h12) begin
                next_hh = 8'h01;        // Wrap from 12 to 1
                // pm stays same here, will be toggled below if needed
            end else begin
                // Increment hours BCD
                // Increment ones digit
                if (hh[3:0] == 4'd9) begin
                    // If ones digit is 9, increment tens and set ones to 0
                    next_hh[3:0] = 4'd0;
                    next_hh[7:4] = hh[7:4] + 4'd1;
                end else begin
                    next_hh[3:0] = hh[3:0] + 4'd1;
                    next_hh[7:4] = hh[7:4];
                end
            end

            // Toggle pm on 11->12 transition
            if (hh == 8'h11)
                next_pm = ~pm;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            pm <= 1'b0;  // AM
            hh <= 8'h12; // 12
            mm <= 8'h00;
            ss <= 8'h00;
        end else if (ena) begin
            if (ss_roll) begin
                ss <= 8'h00;
                if (mm_roll) begin
                    mm <= 8'h00;
                    hh <= next_hh;
                    pm <= next_pm;
                end else begin
                    mm <= next_mm;
                end
            end else begin
                ss <= next_ss;
            end
        end
    end

endmodule