module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Internal BCD digits for seconds and minutes
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour internal binary counter (1 to 12)
reg [3:0] hour_bin; // values 1..12

// Flags for rollovers
wire sec_rollover, min_rollover;

// Seconds and minutes counters combined for fewer clocked blocks
always @(posedge clk) begin
    if (reset) begin
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (ena) begin
        // Seconds increment
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5)
                ss_tens <= 4'd0;
            else
                ss_tens <= ss_tens + 4'd1;
        end else begin
            ss_units <= ss_units + 4'd1;
        end

        // Minutes increment if seconds rollover
        if (ss_tens == 4'd5 && ss_units == 4'd9) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                if (mm_tens == 4'd5)
                    mm_tens <= 4'd0;
                else
                    mm_tens <= mm_tens + 4'd1;
            end else begin
                mm_units <= mm_units + 4'd1;
            end
        end
    end
end

assign sec_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;
assign min_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9) && sec_rollover;

// Hour counter and PM update
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;  // start at 12
        pm       <= 1'b0;   // AM
    end else if (min_rollover) begin
        if (hour_bin == 4'd12) begin
            hour_bin <= 4'd1;
        end else begin
            hour_bin <= hour_bin + 4'd1;
        end

        // Toggle PM at hour roll over from 11 to 12
        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Registered hour BCD output for less combinational logic and switching
reg [7:0] hh_reg;

always @(posedge clk) begin
    if (reset) begin
        hh_reg <= 8'h12; // 0x12 == BCD 12
    end else if (min_rollover) begin
        if (hour_bin == 4'd12) begin
            hh_reg <= 8'h01; // BCD 1
        end else if (hour_bin < 4'd9) begin
            hh_reg <= {4'd0, hour_bin + 4'd1};
        end else begin
            // hour_bin is 9, 10 or 11 after increment
            // Map 10 -> 0x10, 11 -> 0x11
            case(hour_bin + 4'd1)
                4'd10: hh_reg <= 8'h10;
                4'd11: hh_reg <= 8'h11;
                default: hh_reg <= 8'h01; // should not happen
            endcase
        end
    end
end

// To handle initial hh on reset properly
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12;
        mm <= 8'h00;
        ss <= 8'h00;
    end else begin
        hh <= hh_reg;
        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end
end

endmodule