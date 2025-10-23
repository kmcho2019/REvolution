module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

    // BCD digits for seconds and minutes
    reg [3:0] ss_units, ss_tens;
    reg [3:0] mm_units, mm_tens;

    // Hour in binary (1..12)
    reg [3:0] hour_bin;

    // Registered BCD hour output to reduce toggling
    reg [7:0] hh_reg;

    // Sequential seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_units <= 4'd0;
            ss_tens  <= 4'd0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                if (ss_tens == 4'd5) begin
                    ss_tens <= 4'd0;
                end else begin
                    ss_tens <= ss_tens + 4'd1;
                end
            end else begin
                ss_units <= ss_units + 4'd1;
            end
        end
    end

    // Sequential minutes counter increments when seconds roll over from 59 to 00
    wire sec_rollover = (ss_units == 4'd9) && (ss_tens == 4'd5) && ena;
    always @(posedge clk) begin
        if (reset) begin
            mm_units <= 4'd0;
            mm_tens  <= 4'd0;
        end else if (sec_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5) begin
                    mm_tens <= 4'd0;
                end else begin
                    mm_tens <= mm_tens + 4'd1;
                end
            end else begin
                mm_units <= mm_units + 4'd1;
            end
        end
    end

    // Hour counter increments when minutes roll over from 59 to 00
    wire min_rollover = (mm_units == 4'd9) && (mm_tens == 4'd5) && sec_rollover;
    reg pm_next;
    always @(posedge clk) begin
        if (reset) begin
            hour_bin <= 4'd12;
            pm       <= 1'b0;
        end else if (min_rollover) begin
            if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end
            // Toggle PM when hour goes from 11 to 12
            if (hour_bin == 4'd11)
                pm <= ~pm;
        end
    end

    // Update BCD hour output only on hour change to reduce switching
    reg [3:0] hour_bin_last;
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12; // BCD 12
            hour_bin_last <= 4'd12;
        end else if (hour_bin != hour_bin_last) begin
            // Convert binary hour to BCD
            if (hour_bin <= 4'd9)
                hh_reg <= {4'd0, hour_bin};
            else
                hh_reg <= {4'd1, hour_bin - 4'd10};
            hour_bin_last <= hour_bin;
        end
    end

    // Output assignments
    always @(*) begin
        hh = hh_reg;
        mm = {mm_tens, mm_units};
        ss = {ss_tens, ss_units};
    end

endmodule