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
reg [3:0] ss_u, ss_t;
// Minutes BCD digits
reg [3:0] mm_u, mm_t;
// Hours binary counter 1..12
reg [3:0] hour_bin;

always @(posedge clk) begin
    if (reset) begin
        pm       <= 1'b0;     // AM
        hour_bin <= 4'd12;    // 12
        mm_t     <= 4'd0;
        mm_u     <= 4'd0;
        ss_t     <= 4'd0;
        ss_u     <= 4'd0;
    end else if (ena) begin
        // Increment seconds
        if (ss_u == 4'd9) begin
            ss_u <= 4'd0;
            if (ss_t == 4'd5) begin
                ss_t <= 4'd0;
                // Increment minutes
                if (mm_u == 4'd9) begin
                    mm_u <= 4'd0;
                    if (mm_t == 4'd5) begin
                        mm_t <= 4'd0;
                        // Increment hour_bin 1..12
                        if (hour_bin == 4'd12) begin
                            hour_bin <= 4'd1;
                            pm <= ~pm;  // toggle pm on rollover from 12 to 1
                        end else begin
                            hour_bin <= hour_bin + 4'd1;
                            // Toggle pm when hour rolls from 11 to 12 instead of 12->1
                            // Adjust to toggle at 11->12 transition instead:
                            // So correct toggle at 11->12, not 12->1:
                            // But current code toggles at 12->1, must fix
                            // Fix by toggling pm at 11->12:
                            // We'll change this logic below
                        end
                    end else begin
                        mm_t <= mm_t + 4'd1;
                    end
                end else begin
                    mm_u <= mm_u + 4'd1;
                end
            end else begin
                ss_t <= ss_t + 4'd1;
            end
        end else begin
            ss_u <= ss_u + 4'd1;
        end
    end

    // Correct pm toggle: toggle when hour rolls from 11 to 12
    // So after incrementing hour_bin, if previous hour_bin was 11 and now is 12, toggle pm
    // This requires storing previous hour_bin or reorganizing logic

    // To fix this, re-implement hour increment logic as follows:

    if (reset) begin
        pm <= 1'b0;
        hour_bin <= 4'd12;
    end else if (ena) begin
        // Increment seconds as above
        reg hour_will_increment;
        // Calculate if hour increment will happen:
        hour_will_increment = 0;
        if (ss_u == 4'd9 && ss_t == 4'd5 && mm_u == 4'd9 && mm_t == 4'd5) begin
            hour_will_increment = 1;
        end

        // Increment seconds
        if (ss_u == 4'd9) begin
            ss_u <= 4'd0;
            if (ss_t == 4'd5) begin
                ss_t <= 4'd0;
                // Increment minutes
                if (mm_u == 4'd9) begin
                    mm_u <= 4'd0;
                    if (mm_t == 4'd5) begin
                        mm_t <= 4'd0;
                    end else begin
                        mm_t <= mm_t + 4'd1;
                    end
                end else begin
                    mm_u <= mm_u + 4'd1;
                end
            end else begin
                ss_t <= ss_t + 4'd1;
            end
        end else begin
            ss_u <= ss_u + 4'd1;
        end

        if (hour_will_increment) begin
            if (hour_bin == 4'd11) begin
                hour_bin <= 4'd12;
                pm <= ~pm;
            end else if (hour_bin == 4'd12) begin
                hour_bin <= 4'd1;
            end else begin
                hour_bin <= hour_bin + 4'd1;
            end
        end
    end
end

// Convert hour_bin 1..12 to BCD hh output
always @* begin
    if (hour_bin <= 4'd9)
        hh = {4'd0, hour_bin};
    else
        hh = {4'd1, hour_bin - 4'd10};
    mm = {mm_t, mm_u};
    ss = {ss_t, ss_u};
end

endmodule