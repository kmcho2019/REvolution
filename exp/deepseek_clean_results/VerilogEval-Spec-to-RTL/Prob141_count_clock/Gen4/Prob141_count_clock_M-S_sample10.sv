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

    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            {ss_tens, ss_ones} <= 8'h00;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                ss_tens <= ss_tens + 1;
            end else begin
                ss_ones <= ss_ones + 1;
            end
            
            if ({ss_tens, ss_ones} == 8'h59) begin
                {ss_tens, ss_ones} <= 8'h00;
            end
        end
    end

    // Minutes counter
    always @(posedge clk) begin
        if (reset) begin
            {mm_tens, mm_ones} <= 8'h00;
        end else if (ena && {ss_tens, ss_ones} == 8'h59) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                mm_tens <= mm_tens + 1;
            end else begin
                mm_ones <= mm_ones + 1;
            end
            
            if ({mm_tens, mm_ones} == 8'h59) begin
                {mm_tens, mm_ones} <= 8'h00;
            end
        end
    end

    // Hours counter and PM indicator
    always @(posedge clk) begin
        if (reset) begin
            {hh_tens, hh_ones} <= 8'h12;
            pm_reg <= 1'b0;
        end else if (ena && {ss_tens, ss_ones} == 8'h59 && {mm_tens, mm_ones} == 8'h59) begin
            if ({hh_tens, hh_ones} == 8'h12) begin
                {hh_tens, hh_ones} <= 8'h01;
            end else if (hh_ones == 4'd9) begin
                {hh_tens, hh_ones} <= {hh_tens + 1, 4'd0};
            end else begin
                hh_ones <= hh_ones + 1;
            end
            
            // Toggle PM when going from 11 to 12
            if ({hh_tens, hh_ones} == 8'h11) begin
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