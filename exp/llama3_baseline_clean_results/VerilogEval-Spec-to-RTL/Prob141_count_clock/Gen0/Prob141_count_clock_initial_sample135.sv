module TopModule(
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

// Internal signals for hours, minutes, and seconds
reg [3:0] hh_tens;
reg [3:0] hh_ones;
reg [3:0] mm_tens;
reg [3:0] mm_ones;
reg [3:0] ss_tens;
reg [3:0] ss_ones;

// Combinational logic for pm signal
assign pm = (hh_tens == 1 && hh_ones >= 2) || (hh_tens == 0 && hh_ones == 0 && mm_tens == 0 && mm_ones == 0 && ss_tens == 0 && ss_ones == 0)? 0 : (hh_tens == 0 && hh_ones == 1)? 0 : 1;

// Output assignments
assign hh = {hh_tens, hh_ones};
assign mm = {mm_tens, mm_ones};
assign ss = {ss_tens, ss_ones};

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        // Reset to "12:00 AM"
        hh_tens <= 0;
        hh_ones <= 1;
        mm_tens <= 0;
        mm_ones <= 0;
        ss_tens <= 0;
        ss_ones <= 0;
    end else if (ena) begin
        // Increment seconds counter
        if (ss_ones == 9) begin
            ss_ones <= 0;
            if (ss_tens == 5) begin
                ss_tens <= 0;
                // Increment minutes counter
                if (mm_ones == 9) begin
                    mm_ones <= 0;
                    if (mm_tens == 5) begin
                        mm_tens <= 0;
                        // Increment hours counter
                        if (hh_ones == 9) begin
                            hh_ones <= 0;
                            if (hh_tens == 1) begin
                                hh_tens <= 0;
                            end else begin
                                hh_tens <= hh_tens + 1;
                            end
                        end else if (hh_ones == 2 && hh_tens == 1) begin
                            hh_ones <= 1;
                            hh_tens <= 0;
                        end else begin
                            hh_ones <= hh_ones + 1;
                        end
                    end else begin
                        mm_tens <= mm_tens + 1;
                    end
                end else begin
                    mm_ones <= mm_ones + 1;
                end
            end else begin
                ss_tens <= ss_tens + 1;
            end
        end else begin
            ss_ones <= ss_ones + 1;
        end
    end
end

endmodule