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
    reg [3:0] hh_tens, hh_ones;  // BCD hours (01-12)
    reg [3:0] mm_tens, mm_ones;  // BCD minutes (00-59)
    reg [3:0] ss_tens, ss_ones;  // BCD seconds (00-59)

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= 8'h00;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end
        end
    end

    // Minutes counter (only increments when seconds roll over)
    wire sec_roll = ena && (ss_tens == 4'd5) && (ss_ones == 4'd9);
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= 8'h00;
        end else if (sec_roll) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end else begin
                mm_ones <= mm_ones + 1;
            end
        end
    end

    // Hours and PM logic (only increments when minutes roll over)
    wire min_roll = sec_roll && (mm_tens == 4'd5) && (mm_ones == 4'd9);
    always @(posedge clk) begin
        if (reset) begin
            {hh_tens, hh_ones} <= 8'h12;
            pm_reg <= 1'b0;
        end else if (min_roll) begin
            if (hh_ones == 4'd2 && hh_tens == 4'd1) begin  // 12 -> 01
                {hh_tens, hh_ones} <= 8'h01;
                pm_reg <= ~pm_reg;
            end else if (hh_ones == 4'd9) begin  // 09 -> 10
                {hh_tens, hh_ones} <= {4'd1, 4'd0};
            end else begin
                hh_ones <= hh_ones + 1;
            end
        end
    end

    // Output assignments
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};
    assign pm = pm_reg;

endmodule