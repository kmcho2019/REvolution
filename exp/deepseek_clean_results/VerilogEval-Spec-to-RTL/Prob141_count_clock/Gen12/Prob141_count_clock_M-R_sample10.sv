module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // Packed BCD counters
    reg [7:0] ss_reg, mm_reg, hh_reg;
    reg pm_reg;
    
    // Combinational logic for next state
    wire [7:0] next_ss, next_mm, next_hh;
    wire next_pm;
    
    // Seconds counter logic
    assign next_ss = reset ? 8'h00 : 
                    (ena && ss_reg == 8'h59) ? 8'h00 :
                    ena ? (ss_reg[3:0] == 4'h9 ? {ss_reg[7:4] + 1, 4'h0} : ss_reg + 1) : 
                    ss_reg;
    
    // Minutes counter logic
    assign next_mm = reset ? 8'h00 : 
                    (ena && ss_reg == 8'h59 && mm_reg == 8'h59) ? 8'h00 :
                    (ena && ss_reg == 8'h59) ? (mm_reg[3:0] == 4'h9 ? {mm_reg[7:4] + 1, 4'h0} : mm_reg + 1) : 
                    mm_reg;
    
    // Hours counter and PM logic
    wire [7:0] hh_inc = (hh_reg == 8'h12) ? 8'h01 : 
                       (hh_reg[3:0] == 4'h9) ? {hh_reg[7:4] + 1, 4'h0} : 
                       hh_reg + 1;
    
    assign next_hh = reset ? 8'h12 : 
                    (ena && ss_reg == 8'h59 && mm_reg == 8'h59) ? hh_inc : 
                    hh_reg;
    
    assign next_pm = reset ? 1'b0 : 
                    (ena && ss_reg == 8'h59 && mm_reg == 8'h59 && hh_reg == 8'h11) ? ~pm_reg : 
                    pm_reg;

    // Sequential update
    always @(posedge clk) begin
        ss_reg <= next_ss;
        mm_reg <= next_mm;
        hh_reg <= next_hh;
        pm_reg <= next_pm;
    end

    // Output assignments
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;
    assign pm = pm_reg;

endmodule