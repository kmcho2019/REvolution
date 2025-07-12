module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Internal binary counters
    reg [5:0] seconds;  // 0 - 59
    reg [5:0] minutes;  // 0 - 59
    reg [3:0] hours;    // 1 - 12

    // Internal registers holding BCD outputs (to reduce combinational complexity and toggling)
    reg [3:0] ss_tens, ss_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] hh_tens, hh_units;

    // Function to convert binary 0-59 to BCD digits
    function automatic void bin_to_bcd_60(input [5:0] val,
                                         output reg [3:0] tens,
                                         output reg [3:0] units);
        begin
            if (val >= 50)       tens = 4'd5;
            else if (val >= 40)  tens = 4'd4;
            else if (val >= 30)  tens = 4'd3;
            else if (val >= 20)  tens = 4'd2;
            else if (val >= 10)  tens = 4'd1;
            else                 tens = 4'd0;
            units = val - tens*6'd10;
        end
    endfunction

    // Function to convert binary hours (1-12) to BCD
    function automatic void bin_to_bcd_hour(input [3:0] val,
                                           output reg [3:0] tens,
                                           output reg [3:0] units);
        begin
            if (val >= 10) begin
                tens = 4'd1;
                units = val - 4'd10;
            end else begin
                tens = 4'd0;
                units = val;
            end
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Reset counters and outputs to 12:00 AM
            seconds <= 6'd0;
            minutes <= 6'd0;
            hours   <= 4'd12;
            pm      <= 1'b0;

            // Update BCD outputs on reset
            bin_to_bcd_60(6'd0, ss_tens, ss_units);
            bin_to_bcd_60(6'd0, mm_tens, mm_units);
            bin_to_bcd_hour(4'd12, hh_tens, hh_units);

            ss <= {ss_tens, ss_units};
            mm <= {mm_tens, mm_units};
            hh <= {hh_tens, hh_units};
        end else if (ena) begin
            // Increment seconds
            if (seconds == 6'd59) begin
                seconds <= 6'd0;
                // Increment minutes
                if (minutes == 6'd59) begin
                    minutes <= 6'd0;
                    // Increment hours with wrap and pm toggle
                    if (hours == 4'd11) begin
                        hours <= 4'd12;
                        pm <= ~pm;
                    end else if (hours == 4'd12) begin
                        hours <= 4'd1;
                    end else begin
                        hours <= hours + 4'd1;
                    end
                end else begin
                    minutes <= minutes + 6'd1;
                end
            end else begin
                seconds <= seconds + 6'd1;
            end

            // Update BCD outputs on changes
            bin_to_bcd_60(seconds == 6'd59 ? 6'd0 : (seconds + 6'd1), ss_tens, ss_units);
            ss <= {ss_tens, ss_units};

            if (seconds == 6'd59) begin
                bin_to_bcd_60(minutes == 6'd59 ? 6'd0 : (minutes + 6'd1), mm_tens, mm_units);
                mm <= {mm_tens, mm_units};
                if (minutes == 6'd59) begin
                    bin_to_bcd_hour(
                        (hours == 4'd11) ? 4'd12 :
                        (hours == 4'd12) ? 4'd1 :
                        (hours + 4'd1),
                        hh_tens, hh_units
                    );
                    hh <= {hh_tens, hh_units};
                end
            end
        end else begin
            // If not enabled, maintain output registers as-is (no change)
            // No counter update, no BCD output update
        end
    end

endmodule