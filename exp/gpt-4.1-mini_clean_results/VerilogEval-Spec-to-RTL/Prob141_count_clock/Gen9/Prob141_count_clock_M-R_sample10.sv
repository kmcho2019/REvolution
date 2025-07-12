module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// Internal representation:
// Seconds and minutes stored as two 4-bit BCD digits packed into an 8-bit value:
// upper nibble = tens digit (0-5), lower nibble = units digit (0-9).
reg [7:0] seconds_bcd; // 00 to 59
reg [7:0] minutes_bcd; // 00 to 59

// Hours stored as binary from 1 to 12
reg [3:0] hour_bin;    // 1..12

// --- Seconds counter ---
always @(posedge clk) begin
    if (reset) begin
        seconds_bcd <= 8'h00; // 00 seconds
    end else if (ena) begin
        // Extract digits
        if (seconds_bcd[3:0] == 4'd9) begin
            // Units digit rollover
            if (seconds_bcd[7:4] == 4'd5) begin
                // Seconds reach 59, roll over to 00
                seconds_bcd <= 8'h00;
            end else begin
                // Tens digit increment
                seconds_bcd <= {seconds_bcd[7:4] + 4'd1, 4'd0};
            end
        end else begin
            // Units digit increment
            seconds_bcd <= {seconds_bcd[7:4], seconds_bcd[3:0] + 4'd1};
        end
    end
end

// --- Minutes counter ---
always @(posedge clk) begin
    if (reset) begin
        minutes_bcd <= 8'h00; // 00 minutes
    end else if (ena && seconds_bcd == 8'h59) begin
        // Increment minutes only on seconds rollover
        if (minutes_bcd[3:0] == 4'd9) begin
            if (minutes_bcd[7:4] == 4'd5) begin
                // Minutes reach 59, roll over to 00
                minutes_bcd <= 8'h00;
            end else begin
                // Tens digit increment
                minutes_bcd <= {minutes_bcd[7:4] + 4'd1, 4'd0};
            end
        end else begin
            // Units digit increment
            minutes_bcd <= {minutes_bcd[7:4], minutes_bcd[3:0] + 4'd1};
        end
    end
end

// --- Hours and pm counter ---
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12; // 12 o'clock start
        pm <= 1'b0;        // AM
    end else if (ena && seconds_bcd == 8'h59 && minutes_bcd == 8'h59) begin
        // Increment hour on minute and second rollover
        if (hour_bin == 4'd12) begin
            hour_bin <= 4'd1;
        end else begin
            hour_bin <= hour_bin + 4'd1;
        end
        // Toggle pm at transition from 11 to 12
        if (hour_bin == 4'd11) begin
            pm <= ~pm;
        end
    end
end

// --- Hour BCD conversion using case statement ---
reg [7:0] hh_bcd;
always @* begin
    case (hour_bin)
        4'd1:  hh_bcd = 8'h01;
        4'd2:  hh_bcd = 8'h02;
        4'd3:  hh_bcd = 8'h03;
        4'd4:  hh_bcd = 8'h04;
        4'd5:  hh_bcd = 8'h05;
        4'd6:  hh_bcd = 8'h06;
        4'd7:  hh_bcd = 8'h07;
        4'd8:  hh_bcd = 8'h08;
        4'd9:  hh_bcd = 8'h09;
        4'd10: hh_bcd = 8'h10;
        4'd11: hh_bcd = 8'h11;
        4'd12: hh_bcd = 8'h12;
        default: hh_bcd = 8'h12; // Defensive default
    endcase
end

// Assign output ports
assign hh = hh_bcd;
assign mm = minutes_bcd;
assign ss = seconds_bcd;

endmodule