module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [5:0] sec_count;  // 0-59
    reg [5:0] min_count;  // 0-59
    reg [3:0] hour_count; // 1-12
    reg pm_reg;

    // Rollover signals
    wire sec_rollover = (sec_count == 59);
    wire min_rollover = (min_count == 59);
    wire hour_rollover = (hour_count == 12);

    // BCD conversion
    wire [3:0] ss_tens = sec_count / 10;
    wire [3:0] ss_ones = sec_count % 10;
    wire [3:0] mm_tens = min_count / 10;
    wire [3:0] mm_ones = min_count % 10;
    wire [3:0] hh_tens = hour_count / 10;
    wire [3:0] hh_ones = hour_count % 10;

    // Main counter logic
    always @(posedge clk) begin
        if (reset) begin
            sec_count <= 0;
            min_count <= 0;
            hour_count <= 12;
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            if (sec_rollover) begin
                sec_count <= 0;
                // Minutes counter
                if (min_rollover) begin
                    min_count <= 0;
                    // Hours counter
                    if (hour_rollover) begin
                        hour_count <= 1;
                        pm_reg <= ~pm_reg;
                    end else begin
                        hour_count <= hour_count + 1;
                    end
                end else begin
                    min_count <= min_count + 1;
                end
            end else begin
                sec_count <= sec_count + 1;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = {hh_tens, hh_ones};
    assign mm = {mm_tens, mm_ones};
    assign ss = {ss_tens, ss_ones};

endmodule