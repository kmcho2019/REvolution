module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State encoding for AM/PM
    localparam AM = 1'b0;
    localparam PM = 1'b1;
    
    reg pm_state;
    reg [7:0] ss_reg;
    reg [7:0] mm_reg;
    reg [7:0] hh_reg;
    
    // Helper wires for rollover conditions
    wire ss_rollover = (ss_reg == 8'h59);
    wire mm_rollover = (mm_reg == 8'h59);
    wire hh_rollover = (hh_reg == 8'h12);
    
    // BCD increment function
    function [7:0] bcd_inc;
        input [7:0] val;
        reg [3:0] lo, hi;
        begin
            lo = val[3:0];
            hi = val[7:4];
            
            if (lo == 4'd9) begin
                lo = 4'd0;
                hi = hi + 4'd1;
                if (hi == 4'd6) hi = 4'd0;  // Handle 59->00 case
            end else begin
                lo = lo + 4'd1;
            end
            
            bcd_inc = {hi, lo};
        end
    endfunction
    
    // Seconds counter
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 8'h00;
        end else if (ena) begin
            ss_reg <= bcd_inc(ss_reg);
        end
    end
    
    // Minutes counter (enabled by seconds rollover)
    wire min_enable = ena && ss_rollover;
    always @(posedge clk) begin
        if (reset) begin
            mm_reg <= 8'h00;
        end else if (min_enable) begin
            mm_reg <= bcd_inc(mm_reg);
        end
    end
    
    // Hours and AM/PM state machine
    wire hour_enable = min_enable && mm_rollover;
    always @(posedge clk) begin
        if (reset) begin
            hh_reg <= 8'h12;
            pm_state <= AM;
        end else if (hour_enable) begin
            if (hh_rollover) begin
                hh_reg <= 8'h01;  // 12 -> 1
            end else begin
                hh_reg <= bcd_inc(hh_reg);
            end
            
            // Toggle PM at 11->12 transition
            if (hh_reg == 8'h11) begin
                pm_state <= ~pm_state;
            end
        end
    end
    
    // Output assignments
    assign pm = pm_state;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule