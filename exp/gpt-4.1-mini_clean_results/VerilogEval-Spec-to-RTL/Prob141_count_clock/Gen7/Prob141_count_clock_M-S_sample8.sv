module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// Seconds and minutes BCD digits
reg [3:0] ss_units, ss_tens;
reg [3:0] mm_units, mm_tens;

// Hour encoded as 4-bit binary for values 1 to 12
reg [3:0] hour_bin;

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;      // AM
        hour_bin <= 4'd12;     // 12 hours
        mm_tens  <= 4'd0;
        mm_units <= 4'd0;
        ss_tens  <= 4'd0;
        ss_units <= 4'd0;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss_units <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss_tens <= 4'd0;
                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm_tens <= 4'd0;
                        // Increment hour with rollover at 12
                        // Toggle pm if hour was 11 before increment
                        if (hour_bin == 4'd11)
                            pm <= ~pm;
                        
                        if (hour_bin == 4'd12)
                            hour_bin <= 4'd1;
                        else
                            hour_bin <= hour_bin + 4'd1;
                    end else begin
                        mm_tens <= mm_tens + 4'd1;
                    end
                end else begin
                    mm_units <= mm_units + 4'd1;
                end
            end else begin
                ss_tens <= ss_tens + 4'd1;
            end
        end else begin
            ss_units <= ss_units + 4'd1;
        end
    end
end

// Convert hour_bin (1-12) to BCD digits
// tens digit = 1 if hour_bin >= 10, else 0
// units digit = hour_bin - 10 if >= 10 else hour_bin
wire [3:0] hh_tens = (hour_bin >= 4'd10) ? 4'd1 : 4'd0;
wire [3:0] hh_units = (hour_bin >= 4'd10) ? (hour_bin - 4'd10) : hour_bin;

always @(*) begin
    hh = {hh_tens, hh_units};
    mm = {mm_tens, mm_units};
    ss = {ss_tens, ss_units};
end

endmodule