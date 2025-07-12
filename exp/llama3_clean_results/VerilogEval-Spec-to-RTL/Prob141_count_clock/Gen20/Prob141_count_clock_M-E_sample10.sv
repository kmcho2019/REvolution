module SecondCounter(
    input clk,
    input reset,
    input ena,
    output [7:0] ss
);

    reg [5:0] seconds_int;
    reg [7:0] ss_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            seconds_int <= 0;
        end else if (ena) begin
            if (seconds_int == 59) begin
                seconds_int <= 0;
            end else begin
                seconds_int <= seconds_int + 1;
            end
        end
    end

    always_comb begin
        ss_reg = {4'b0000, seconds_int[5:4], seconds_int[3:0]};
        ss = ss_reg;
    end

endmodule

module MinuteCounter(
    input clk,
    input reset,
    input ena,
    output [7:0] mm
);

    reg [5:0] minutes_int;
    reg [7:0] mm_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            minutes_int <= 0;
        end else if (ena) begin
            if (minutes_int == 59) begin
                minutes_int <= 0;
            end else begin
                minutes_int <= minutes_int + 1;
            end
        end
    end

    always_comb begin
        mm_reg = {4'b0000, minutes_int[5:4], minutes_int[3:0]};
        mm = mm_reg;
    end

endmodule

module HourCounter(
    input clk,
    input reset,
    input ena,
    input second_pulse,
    input minute_pulse,
    output [7:0] hh,
    output pm
);

    reg [3:0] hours_int;
    reg pm_int;
    reg [7:0] hh_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            hours_int <= 0; // Start at 12:00 AM (hours = 0 for 12)
            pm_int <= 0; // AM
        end else if (ena) begin
            if (minute_pulse) begin
                if (hours_int == 11) begin
                    hours_int <= 0;
                    pm_int <= ~pm_int; // Toggle AM/PM
                end else begin
                    hours_int <= hours_int + 1;
                end
            end
        end
    end

    always_comb begin
        if (hours_int == 0) begin // 12 AM/PM
            hh_reg = 8'b0001_0010;
        end else if (hours_int <= 9) begin
            hh_reg = {4'b0000, hours_int};
        end else begin
            hh_reg = {4'b0001, hours_int};
        end

        hh = hh_reg;
        pm = pm_int;
    end

endmodule

module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    wire second_pulse;
    wire minute_pulse;
    reg [7:0] ss_reg;
    reg [7:0] mm_reg;

    SecondCounter seconds_counter(
       .clk(clk),
       .reset(reset),
       .ena(ena),
       .ss(ss_reg)
    );

    assign second_pulse = (ss_reg == 8'b0000_0000)? 1'b1 : 1'b0;

    MinuteCounter minutes_counter(
       .clk(clk),
       .reset(reset),
       .ena(second_pulse),
       .mm(mm_reg)
    );

    assign minute_pulse = (mm_reg == 8'b0000_0000)? 1'b1 : 1'b0;

    HourCounter hours_counter(
       .clk(clk),
       .reset(reset),
       .ena(minute_pulse),
       .second_pulse(second_pulse),
       .minute_pulse(minute_pulse),
       .hh(hh),
       .pm(pm)
    );

    assign ss = ss_reg;
    assign mm = mm_reg;

endmodule