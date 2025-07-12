module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State tracking
    reg phase;  // 0=even phase, 1=odd phase
    reg pm_state;
    
    // BCD counters (separate tens/units)
    reg [3:0] ss_tens, ss_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] hh_tens, hh_units;
    
    // Rollover conditions
    wire ss_max = (ss_tens == 4'd5) && (ss_units == 4'd9);
    wire mm_max = (mm_tens == 4'd5) && (mm_units == 4'd9);
    wire hh_max = (hh_tens == 4'd1) && (hh_units == 4'd2);
    
    // Output assignments
    assign ss = {ss_tens, ss_units};
    assign mm = {mm_tens, mm_units};
    assign hh = {hh_tens, hh_units};
    assign pm = pm_state;
    
    // Phase counter
    always @(posedge clk) begin
        if (reset) begin
            phase <= 1'b0;
        end else if (ena) begin
            phase <= ~phase;
        end
    end
    
    // Even phase processing (seconds and minutes)
    always @(posedge clk) begin
        if (reset) begin
            ss_tens <= 4'd0;
            ss_units <= 4'd0;
            mm_tens <= 4'd0;
            mm_units <= 4'd0;
        end else if (ena && !phase) begin
            // Seconds counter
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_units <= ss_units + 1;
            end
            
            // Minutes counter (only on second rollover)
            if (ss_max) begin
                if (mm_units == 4'd9) begin
                    mm_units <= 4'd0;
                    mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
                end else begin
                    mm_units <= mm_units + 1;
                end
            end
        end
    end
    
    // Odd phase processing (hours and PM)
    always @(posedge clk) begin
        if (reset) begin
            hh_tens <= 4'd1;
            hh_units <= 4'd2;
            pm_state <= 1'b0;
        end else if (ena && phase && ss_max && mm_max) begin
            // Hours counter
            if (hh_units == 4'd9) begin
                hh_units <= 4'd0;
                hh_tens <= hh_tens + 1;
            end else if (hh_max) begin
                hh_tens <= 4'd0;
                hh_units <= 4'd1;
            end else begin
                hh_units <= hh_units + 1;
            end
            
            // PM state toggle at 11->12 transition
            if (hh_tens == 4'd1 && hh_units == 4'd1) begin
                pm_state <= ~pm_state;
            end
        end
    end

endmodule