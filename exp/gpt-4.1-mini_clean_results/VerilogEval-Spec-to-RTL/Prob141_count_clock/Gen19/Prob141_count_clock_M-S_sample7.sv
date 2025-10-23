module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds BCD digits
reg [3:0] ss_units, ss_tens;
// Minutes BCD digits
reg [3:0] mm_units, mm_tens;
// Hour binary counter (1..12)
reg [3:0] hour_bin;

// Seconds counter
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

wire sec_rollover = ena && (ss_tens == 4'd5) && (ss_units == 4'd9);

// Minutes counter
always @(posedge clk) begin
    if (reset) begin
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (sec_rollover) begin
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

wire min_rollover = sec_rollover && (mm_tens == 4'd5) && (mm_units == 4'd9);

// Hour counter
always @(posedge clk) begin
    if (reset) begin
        hour_bin <= 4'd12;
        pm       <= 1'b0;
    end else if (min_rollover) begin
        if (hour_bin == 4'd12)
            hour_bin <= 4'd1;
        else
            hour_bin <= hour_bin + 4'd1;

        if (hour_bin == 4'd11)
            pm <= ~pm;
    end
end

// Synchronously update hh output as BCD digits based on hour_bin without combinational function
always @(posedge clk) begin
    if (reset) begin
        hh <= 8'h12; // 0x12 BCD = 12
        mm <= 8'h00;
        ss <= 8'h00;
    end else begin
        // Convert hour_bin (1..12) to BCD tens and units
        if (hour_bin < 4'd10)
            hh <= {4'd0, hour_bin};
        else
            hh <= {4'd1, hour_bin - 4'd10};

        mm <= {mm_tens, mm_units};
        ss <= {ss_tens, ss_units};
    end
end

endmodule