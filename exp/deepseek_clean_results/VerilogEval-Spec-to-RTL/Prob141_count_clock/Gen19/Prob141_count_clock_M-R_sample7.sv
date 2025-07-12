module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Seconds counter (0-59)
    reg [3:0] ss_lo;
    reg [2:0] ss_hi;
    wire ss_rollover = (ss_hi == 3'd5) && (ss_lo == 4'd9);

    // Minutes counter (0-59)
    reg [3:0] mm_lo;
    reg [2:0] mm_hi;
    wire mm_rollover = (mm_hi == 3'd5) && (mm_lo == 4'd9) && ss_rollover;

    // Hours counter (1-12)
    reg [3:0] hh_lo;
    reg [0:0] hh_hi;
    wire [3:0] hh_val = {hh_hi, hh_lo[2:0]};

    // PM indicator (combinational)
    assign pm = (hh_val >= 4'd12) || (hh_val == 4'd0);

    // Output assignments
    assign ss = {ss_hi, ss_lo};
    assign mm = {mm_hi, mm_lo};
    assign hh = {hh_hi, hh_lo};

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_hi <= 0;
            ss_lo <= 0;
        end else if (ena) begin
            if (ss_lo == 9) begin
                ss_lo <= 0;
                ss_hi <= (ss_hi == 5) ? 0 : ss_hi + 1;
            end else begin
                ss_lo <= ss_lo + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            mm_hi <= 0;
            mm_lo <= 0;
        end else if (ena && ss_rollover) begin
            if (mm_lo == 9) begin
                mm_lo <= 0;
                mm_hi <= (mm_hi == 5) ? 0 : mm_hi + 1;
            end else begin
                mm_lo <= mm_lo + 1;
            end
        end
    end

    // Hours counter
    always @(posedge clk) begin
        if (reset) begin
            hh_hi <= 1;
            hh_lo <= 2; // 12
        end else if (ena && mm_rollover) begin
            if (hh_val == 12) begin
                hh_hi <= 0;
                hh_lo <= 1; // 1
            end else if (hh_lo == 9) begin
                hh_hi <= 1;
                hh_lo <= 0; // 10
            end else begin
                hh_lo <= hh_lo + 1;
            end
        end
    end

endmodule