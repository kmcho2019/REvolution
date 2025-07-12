module TopModule(
    input  wire       clk,
    input  wire       reset,
    input  wire       ena,
    output reg        pm,
    output reg [7:0]  hh,
    output reg [7:0]  mm,
    output reg [7:0]  ss
);

// BCD digits are packed as {tens, units}
wire [3:0] ss_units = ss[3:0];
wire [3:0] ss_tens  = ss[7:4];
wire [3:0] mm_units = mm[3:0];
wire [3:0] mm_tens  = mm[7:4];
wire [3:0] hh_units = hh[3:0];
wire [3:0] hh_tens  = hh[7:4];

always @(posedge clk) begin
    if (reset) begin
        // Reset to 12:00:00 AM
        hh <= 8'h12;  // 0x12 BCD = 12 hours
        mm <= 8'h00;
        ss <= 8'h00;
        pm <= 1'b0;
    end else if (ena) begin
        // Increment seconds
        if (ss_units == 4'd9) begin
            ss[3:0] <= 4'd0;
            if (ss_tens == 4'd5) begin
                ss[7:4] <= 4'd0;
                // Increment minutes
                if (mm_units == 4'd9) begin
                    mm[3:0] <= 4'd0;
                    if (mm_tens == 4'd5) begin
                        mm[7:4] <= 4'd0;
                        // Increment hours (01-12)
                        if (hh == 8'h12) begin
                            hh <= 8'h01;
                            pm <= ~pm;  // toggle pm on rollover from 12 to 1
                        end else if (hh_units == 4'd9) begin
                            hh <= { (hh_tens + 4'd1), 4'd0 };
                        end else begin
                            hh[3:0] <= hh_units + 4'd1;
                        end
                    end else begin
                        mm[7:4] <= mm_tens + 4'd1;
                    end
                end else begin
                    mm[3:0] <= mm_units + 4'd1;
                end
            end else begin
                ss[7:4] <= ss_tens + 4'd1;
            end
        end else begin
            ss[3:0] <= ss_units + 4'd1;
        end
    end
end

endmodule