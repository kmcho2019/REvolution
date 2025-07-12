module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [3:0] ss_ones, ss_tens;
    reg [3:0] mm_ones, mm_tens;
    reg [3:0] hh_ones, hh_tens;

    // Rollover detection
    wire ss_roll = (ss_ones == 4'd9) && (ss_tens == 4'd5);
    wire mm_roll = (mm_ones == 4'd9) && (mm_tens == 4'd5);
    wire hh_12   = (hh_ones == 4'd2) && (hh_tens == 4'd1);

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= 8'h00;
        end else if (ena) begin
            if (ss_roll) begin
                {ss_tens, ss_ones} <= 8'h00;
            end else if (ss_ones == 4'd9) begin
                {ss_tens, ss_ones} <= {ss_tens + 4'd1, 4'd0};
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end
    end

    // Minutes counter (enabled by seconds rollover)
    wire min_ena = ena && ss_roll;
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= 8'h00;
        end else if (min_ena) begin
            if (mm_roll) begin
                {mm_tens, mm_ones} <= 8'h00;
            end else if (mm_ones == 4'd9) begin
                {mm_tens, mm_ones} <= {mm_tens + 4'd1, 4'd0};
            end else begin
                mm_ones <= mm_ones + 4'd1;
            end
        end
    end

    // Hours counter (enabled by minutes rollover)
    wire hour_ena = min_ena && mm_roll;
    always @(posedge clk) begin
        if (reset) begin
            {hh_tens, hh_ones} <= 8'h12;
            pm_reg <= 1'b0;
        end else if (hour_ena) begin
            // Special case for 12 -> 1 transition
            if (hh_12) begin
                {hh_tens, hh_ones} <= 8'h01;
            end 
            // Normal increment
            else if (hh_ones == 4'd9) begin
                {hh_tens, hh_ones} <= {hh_tens + 4'd1, 4'd0};
            end else begin
                hh_ones <= hh_ones + 4'd1;
            end

            // PM toggle only at 11:59 -> 12:00 transition
            if (hh_ones == 4'd1 && hh_tens == 4'd1 && mm_roll) begin
                pm_reg <= ~pm_reg;
            end
        end
    end

    // Output assignments
    assign pm = pm_reg;
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};

endmodule