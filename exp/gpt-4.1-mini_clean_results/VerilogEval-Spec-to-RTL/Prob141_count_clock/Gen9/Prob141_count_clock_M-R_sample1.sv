module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds digits (BCD)
reg [3:0] ss_units;
reg [3:0] ss_tens;
wire ss_rollover;

// Minutes digits (BCD)
reg [3:0] mm_units;
reg [3:0] mm_tens;
wire mm_rollover;

// Hours stored as binary 1..12
reg [3:0] hour_bin;
wire hr_rollover;

// Increment seconds when ena is asserted
// Generate rollover pulse when seconds reach 59->00
always @(posedge clk) begin
    if (reset) begin
        ss_units <= 4'd0;
        ss_tens  <= 4'd0;
    end else if (ena) begin
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5)
                ss_tens <= 4'd0;
            else
                ss_tens <= ss_tens + 4'd1;
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

assign ss_rollover = (ena && (ss_tens == 4'd5) && (ss_units == 4'd9));

// Increment minutes when seconds roll over
always @(posedge clk) begin
    if (reset) begin
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (ss_rollover) begin
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

assign mm_rollover = (ss_rollover && (mm_tens == 4'd5) && (mm_units == 4'd9));

// Increment hour when minutes roll over
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;  // Reset to 12
        pm       <= 1'b0;   // AM
    end else if (mm_rollover) begin
        if (hour_bin == 4'd11) begin
            hour_bin <= 4'd12;
            pm       <= ~pm;   // Toggle PM at 11->12 transition
        end else if (hour_bin == 4'd12) begin
            hour_bin <= 4'd1;
            // pm unchanged
        end else begin
            hour_bin <= hour_bin + 4'd1;
        end
    end
end

// Convert binary hour (1-12) to BCD
always @(*) begin
    if (hour_bin >= 4'd10) begin
        hh = {4'd1, hour_bin - 4'd10};
    end else begin
        hh = {4'd0, hour_bin};
    end
end

// Minutes and seconds outputs combined from BCD digits
always @(*) begin
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule