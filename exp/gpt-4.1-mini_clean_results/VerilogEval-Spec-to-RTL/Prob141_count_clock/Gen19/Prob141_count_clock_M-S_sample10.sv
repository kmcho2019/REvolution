module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    reg [5:0] seconds; // 0-59
    reg [5:0] minutes; // 0-59
    reg [3:0] hours;   // 1-12

    // Counting logic with synchronous reset and enable
    always @(posedge clk) begin
        if (reset) begin
            pm      <= 1'b0;    // AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
        end else if (ena) begin
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Simple combinational BCD conversion by direct logic
    reg [3:0] ss_tens, ss_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] hh_tens, hh_units;

    always @* begin
        // Seconds tens digit
        if (seconds >= 50)      ss_tens = 4'd5;
        else if (seconds >= 40) ss_tens = 4'd4;
        else if (seconds >= 30) ss_tens = 4'd3;
        else if (seconds >= 20) ss_tens = 4'd2;
        else if (seconds >= 10) ss_tens = 4'd1;
        else                    ss_tens = 4'd0;

        ss_units = seconds - (ss_tens * 4'd10);

        // Minutes tens digit
        if (minutes >= 50)      mm_tens = 4'd5;
        else if (minutes >= 40) mm_tens = 4'd4;
        else if (minutes >= 30) mm_tens = 4'd3;
        else if (minutes >= 20) mm_tens = 4'd2;
        else if (minutes >= 10) mm_tens = 4'd1;
        else                    mm_tens = 4'd0;

        mm_units = minutes - (mm_tens * 4'd10);

        // Hours tens digit (1-12)
        if (hours >= 10) begin
            hh_tens = 4'd1;
            hh_units = hours - 4'd10;
        end else begin
            hh_tens = 4'd0;
            hh_units = hours;
        end

        // Assign BCD outputs
        ss = {ss_tens, ss_units};
        mm = {mm_tens, mm_units};
        hh = {hh_tens, hh_units};
    end

endmodule