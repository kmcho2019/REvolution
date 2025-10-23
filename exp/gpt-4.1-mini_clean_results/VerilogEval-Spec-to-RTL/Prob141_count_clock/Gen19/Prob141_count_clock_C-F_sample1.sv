module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // Separate BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Internal hour counter in binary (1..12)
    reg [3:0] hour_bin;

    // Combinational next-state registers for seconds and minutes digits
    reg [3:0] next_ss_units, next_ss_tens;
    reg [3:0] next_mm_units, next_mm_tens;

    // Flags for rollover signals
    wire sec_rollover;
    wire min_rollover;

    // To detect hour change for output update
    reg [3:0] prev_hour_bin;
    reg       hour_changed;

    // Convert binary hour (1..12) to BCD (two digits)
    function [7:0] bin_to_bcd_hour(input [3:0] bin_hour);
        begin
            if (bin_hour <= 4'd9)
                bin_to_bcd_hour = {4'd0, bin_hour};
            else
                bin_to_bcd_hour = {4'd1, bin_hour - 4'd10};
        end
    endfunction

    // Combinational logic for seconds next state when ena
    always @* begin
        // default hold current values
        next_ss_units = ss_units;
        next_ss_tens  = ss_tens;
        if (ena) begin
            if (ss_units == 4'd9) begin
                next_ss_units = 4'd0;
                if (ss_tens == 4'd5)
                    next_ss_tens = 4'd0;
                else
                    next_ss_tens = ss_tens + 4'd1;
            end else begin
                next_ss_units = ss_units + 4'd1;
            end
        end
    end

    assign sec_rollover = ena && (ss_tens == 4'd5) && (ss_units == 4'd9);

    // Combinational logic for minutes next state on seconds rollover
    always @* begin
        next_mm_units = mm_units;
        next_mm_tens  = mm_tens;
        if (sec_rollover) begin
            if (mm_units == 4'd9) begin
                next_mm_units = 4'd0;
                if (mm_tens == 4'd5)
                    next_mm_tens = 4'd0;
                else
                    next_mm_tens = mm_tens + 4'd1;
            end else begin
                next_mm_units = mm_units + 4'd1;
            end
        end
    end

    assign min_rollover = sec_rollover && (mm_tens == 4'd5) && (mm_units == 4'd9);

    // Sequential logic: all counters updated synchronously with highest priority reset
    always @(posedge clk) begin
        if (reset) begin
            ss_units   <= 4'd0;
            ss_tens    <= 4'd0;
            mm_units   <= 4'd0;
            mm_tens    <= 4'd0;
            hour_bin   <= 4'd12;   // 12-hour format start
            pm         <= 1'b0;    // AM
            prev_hour_bin <= 4'd12;
            hh         <= 8'd0;    // Initialize output hh
            mm         <= 8'd0;
            ss         <= 8'd0;
            hour_changed <= 1'b1;  // Force output update after reset
        end else begin
            // Update seconds digits only when ena asserted or reset
            if (ena) begin
                if (next_ss_units != ss_units)
                    ss_units <= next_ss_units;
                if (next_ss_tens != ss_tens)
                    ss_tens <= next_ss_tens;
            end

            // Update minutes digits only on seconds rollover
            if (sec_rollover) begin
                if (next_mm_units != mm_units)
                    mm_units <= next_mm_units;
                if (next_mm_tens != mm_tens)
                    mm_tens <= next_mm_tens;
            end

            // Hour update only on minute rollover
            if (min_rollover) begin
                if (hour_bin == 4'd12)
                    hour_bin <= 4'd1;
                else
                    hour_bin <= hour_bin + 4'd1;

                // Toggle pm only on hour roll 11->12
                if (hour_bin == 4'd11)
                    pm <= ~pm;
            end

            // Detect hour change for output update
            if (hour_bin != prev_hour_bin) begin
                prev_hour_bin <= hour_bin;
                hour_changed <= 1'b1;
            end else begin
                hour_changed <= 1'b0;
            end

            // Update outputs only if changed (min, sec always updated on enable)
            // Update mm output if min changes (only changes on sec_rollover)
            if (sec_rollover)
                mm <= {mm_tens, mm_units};

            // Update ss output if ena
            if (ena)
                ss <= {ss_tens, ss_units};

            // Update hh output only when hour changes
            if (hour_changed)
                hh <= bin_to_bcd_hour(hour_bin);
        end
    end

endmodule