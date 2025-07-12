module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD digits (tens:bits[7:4], units:bits[3:0])
    reg [7:0] ss_reg = 0;
    reg [7:0] mm_reg = 0;
    reg [7:0] hh_reg = 8'h12;  // Start at 12
    
    reg pm_reg = 0;
    
    // Rollover flags
    wire ss_roll = (ss_reg == 8'h59);
    wire mm_roll = (mm_reg == 8'h59);
    wire hh_roll = (hh_reg == 8'h11) || (hh_reg == 8'h12);
    
    // BCD increment function
    function [7:0] bcd_inc;
        input [7:0] val;
        input carry_in;
        reg [7:0] result;
        begin
            result = val + carry_in;
            if (result[3:0] > 9) begin
                result[3:0] = result[3:0] - 10;
                result[7:4] = result[7:4] + 1;
            end
            if (result[7:4] > 9) begin
                result[7:4] = result[7:4] - 10;
            end
            bcd_inc = result;
        end
    endfunction
    
    // Hour state transitions
    always @(posedge clk) begin
        if (reset) begin
            ss_reg <= 0;
            mm_reg <= 0;
            hh_reg <= 8'h12;
            pm_reg <= 0;
        end else if (ena) begin
            // Seconds counter
            ss_reg <= bcd_inc(ss_reg, 1'b1);
            
            // Minutes counter (on seconds rollover)
            if (ss_roll) begin
                mm_reg <= bcd_inc(mm_reg, 1'b1);
            end
            
            // Hours counter (on minutes and seconds rollover)
            if (ss_roll && mm_roll) begin
                case (hh_reg)
                    8'h11: begin  // 11 -> 12
                        hh_reg <= 8'h12;
                        pm_reg <= ~pm_reg;
                    end
                    8'h12: begin  // 12 -> 01
                        hh_reg <= 8'h01;
                    end
                    default: begin
                        hh_reg <= bcd_inc(hh_reg, 1'b1);
                    end
                endcase
            end
        end
    end
    
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule