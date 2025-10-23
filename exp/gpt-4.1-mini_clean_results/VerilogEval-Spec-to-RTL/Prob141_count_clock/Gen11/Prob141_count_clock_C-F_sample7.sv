module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output wire [7:0] hh,
    output wire [7:0] mm,
    output wire [7:0] ss
);

// -----------------------------------------------------------------------------
// Seconds counter (BCD): 00 to 59
reg [3:0] ss_units;
reg [3:0] ss_tens;
wire ss_rollover;

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

// -----------------------------------------------------------------------------
// Minutes counter (BCD): 00 to 59
reg [3:0] mm_units;
reg [3:0] mm_tens;
wire mm_rollover;

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

// -----------------------------------------------------------------------------
// Hour counter (binary 1 to 12) with PM toggle at 11->12 rollover
reg [3:0] hour_bin;

always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm       <= 1'b0;  // AM
    end else if (mm_rollover) begin
        if (hour_bin == 4'd11) begin
            hour_bin <= 4'd12;
            pm       <= ~pm; // Toggle PM on 11->12 transition
        end else if (hour_bin == 4'd12) begin
            hour_bin <= 4'd1;
            // pm unchanged
        end else begin
            hour_bin <= hour_bin + 4'd1;
        end
    end
end

// -----------------------------------------------------------------------------
// Combinational logic for output BCD conversion

// Hours: binary 1-12 converted to BCD 8-bit (two digits)
// If hour_bin >= 10: BCD tens=1, units=hour_bin-10
// Else tens=0, units=hour_bin
wire [3:0] hh_tens = (hour_bin >= 4'd10) ? 4'd1 : 4'd0;
wire [3:0] hh_units = (hour_bin >= 4'd10) ? (hour_bin - 4'd10) : hour_bin;

// Output assignments
assign hh = {hh_tens, hh_units};
assign mm = {mm_tens, mm_units};
assign ss = {ss_tens, ss_units};

endmodule