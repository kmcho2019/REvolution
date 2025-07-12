module TopModule(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [5:0] sec_cnt;
reg [5:0] min_cnt;
reg [3:0] hr_cnt;

always @(posedge clk) begin
    if (reset) begin
        // Reset the clock to 12:00 AM
        sec_cnt <= 0;
        min_cnt <= 0;
        hr_cnt <= 0; // 12 in BCD is 0001, but we'll use 0000 for simplicity
        pm <= 1'b0; // AM
    end else if (ena) begin
        // Increment the seconds counter
        if (sec_cnt == 59) begin
            sec_cnt <= 0;
            // Increment the minutes counter
            if (min_cnt == 59) begin
                min_cnt <= 0;
                // Increment the hours counter
                if (hr_cnt == 11) begin // 11 in BCD is 12, so we wrap around to 1
                    hr_cnt <= 1; // 01 in BCD
                    pm <= ~pm; // Toggle AM/PM
                end else begin
                    hr_cnt <= hr_cnt + 1;
                end
            end else begin
                min_cnt <= min_cnt + 1;
            end
        end else begin
            sec_cnt <= sec_cnt + 1;
        end
    end
end

always @(*) begin
    // Convert internal counters to output BCD format
    hh = {4'b0000, hr_cnt};
    mm = {4'b0000, min_cnt};
    ss = {4'b0000, sec_cnt};
end

endmodule