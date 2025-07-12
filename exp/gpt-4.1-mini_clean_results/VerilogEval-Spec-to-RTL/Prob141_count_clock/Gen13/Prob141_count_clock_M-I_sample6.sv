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
// Hours BCD digits (01-12)
reg [3:0] hh_units, hh_tens;

// Seconds counter
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

// Minutes counter, increments when seconds roll from 59 to 00
wire sec_rollover = (ss_units == 4'd9) && (ss_tens == 4'd5);

always @(posedge clk) begin
    if (reset) begin
        mm_units <= 4'd0;
        mm_tens  <= 4'd0;
    end else if (ena && sec_rollover) begin
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

// Hours counter, increments when minutes roll from 59 to 00
wire min_rollover = (mm_units == 4'd9) && (mm_tens == 4'd5);

always @(posedge clk) begin
    if (reset) begin
        hh_units <= 4'd2;  // tens = 1 for 12
        hh_tens  <= 4'd1;
        pm       <= 1'b0;  // AM
    end else if (ena && sec_rollover && min_rollover) begin
        // Increment hours BCD (01 to 12)
        if (hh_tens == 4'd1 && hh_units == 4'd2) begin
            // 12 -> 01 and toggle pm
            hh_tens <= 4'd0;
            hh_units <= 4'd1;
            pm <= ~pm;
        end else if (hh_units == 4'd9) begin
            // Units roll over (e.g., 09 -> 10)
            hh_units <= 4'd0;
            hh_tens <= hh_tens + 4'd1;
        end else begin
            hh_units <= hh_units + 4'd1;
        end
    end
end

// Output assignments
always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule