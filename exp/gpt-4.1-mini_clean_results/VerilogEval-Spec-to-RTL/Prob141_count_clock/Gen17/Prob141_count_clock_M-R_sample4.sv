module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output wire       pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// BCD counters for seconds and minutes
reg [7:0] bcd_seconds; // [7:4]: tens, [3:0]: units
reg [7:0] bcd_minutes; // [7:4]: tens, [3:0]: units

// Binary hour counter (1..12)
reg [3:0] hour_bin;
reg       pm_reg;

// Carry signals for increments
wire sec_units_carry;
wire sec_tens_carry;
wire sec_rollover;
wire min_units_carry;
wire min_tens_carry;
wire min_rollover;

// Extract digits for clarity
wire [3:0] ss_units = bcd_seconds[3:0];
wire [3:0] ss_tens  = bcd_seconds[7:4];
wire [3:0] mm_units = bcd_minutes[3:0];
wire [3:0] mm_tens  = bcd_minutes[7:4];

// Seconds increment logic
assign sec_units_carry = ena && (ss_units == 4'd9);
assign sec_tens_carry  = sec_units_carry && (ss_tens == 4'd5);
assign sec_rollover    = sec_tens_carry;

// Minutes increment logic
assign min_units_carry = sec_rollover && (mm_units == 4'd9);
assign min_tens_carry  = min_units_carry && (mm_tens == 4'd5);
assign min_rollover    = min_tens_carry;

// Seconds and minutes counters combined always block
always @(posedge clk) begin
    if (reset) begin
        bcd_seconds <= 8'h00; // 00 seconds
        bcd_minutes <= 8'h00; // 00 minutes
    end else begin
        if (ena) begin
            // Increment seconds units digit or roll over
            if (ss_units == 4'd9)
                bcd_seconds[3:0] <= 4'd0;
            else
                bcd_seconds[3:0] <= ss_units + 4'd1;

            // Increment seconds tens digit on units rollover
            if (sec_units_carry) begin
                if (ss_tens == 4'd5)
                    bcd_seconds[7:4] <= 4'd0;
                else
                    bcd_seconds[7:4] <= ss_tens + 4'd1;
            end
        end

        if (sec_rollover) begin
            // Increment minutes units digit or roll over
            if (mm_units == 4'd9)
                bcd_minutes[3:0] <= 4'd0;
            else
                bcd_minutes[3:0] <= mm_units + 4'd1;

            // Increment minutes tens digit on units rollover
            if (min_units_carry) begin
                if (mm_tens == 4'd5)
                    bcd_minutes[7:4] <= 4'd0;
                else
                    bcd_minutes[7:4] <= mm_tens + 4'd1;
            end
        end
    end
end

// Hour counter and pm toggle on minute rollover
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm_reg   <= 1'b0; // AM
    end else if (min_rollover) begin
        if (hour_bin == 4'd12) begin
            hour_bin <= 4'd1;
        end else begin
            hour_bin <= hour_bin + 4'd1;
        end

        // Toggle pm when hour changes from 11 to 12
        if (hour_bin == 4'd11)
            pm_reg <= ~pm_reg;
    end
end

// Convert binary hour (1..12) to BCD
wire [7:0] hour_bcd = (hour_bin <= 4'd9) ? {4'd0, hour_bin} : {4'd1, hour_bin - 4'd10};

// Assign outputs
assign hh = hour_bcd;
assign mm = bcd_minutes;
assign ss = bcd_seconds;
assign pm = pm_reg;

endmodule