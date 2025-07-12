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
    reg [7:0] ss_reg;  // seconds in BCD (hi nibble: tens, lo nibble: units)
    reg [7:0] mm_reg;  // minutes in BCD
    reg [7:0] hh_reg;  // hours in BCD
    
    // Next state signals
    wire [7:0] ss_next, mm_next, hh_next;
    wire pm_next;
    
    // Seconds counter logic
    assign ss_next = reset ? 8'h00 : 
                    (ena) ? ((ss_reg[3:0] == 4'd9) ? 
                            ((ss_reg[7:4] == 4'd5) ? 8'h00 : 
                            {ss_reg[7:4] + 4'd1, 4'h0}) : 
                            {ss_reg[7:4], ss_reg[3:0] + 4'd1}) : 
                    ss_reg;
    
    // Minutes counter logic (only increments when seconds roll over)
    assign mm_next = reset ? 8'h00 : 
                    (ena && (ss_reg == 8'h59)) ? 
                    ((mm_reg[3:0] == 4'd9) ? 
                    ((mm_reg[7:4] == 4'd5) ? 8'h00 : 
                    {mm_reg[7:4] + 4'd1, 4'h0}) : 
                    {mm_reg[7:4], mm_reg[3:0] + 4'd1}) : 
                    mm_reg;
    
    // Hours counter logic (only increments when minutes roll over)
    assign hh_next = reset ? 8'h12 : 
                    (ena && (ss_reg == 8'h59) && (mm_reg == 8'h59)) ? 
                    ((hh_reg == 8'h12) ? 8'h01 : 
                    (hh_reg[3:0] == 4'd9) ? {hh_reg[7:4] + 4'd1, 4'h0} : 
                    {hh_reg[7:4], hh_reg[3:0] + 4'd1}) : 
                    hh_reg;
    
    // PM indicator logic
    assign pm_next = reset ? 1'b0 : 
                   (ena && (ss_reg == 8'h59) && (mm_reg == 8'h59) && (hh_reg == 8'h11)) ? 
                   ~pm_reg : pm_reg;
    
    // Sequential logic for all registers
    always @(posedge clk) begin
        ss_reg <= ss_next;
        mm_reg <= mm_next;
        hh_reg <= hh_next;
        pm_reg <= pm_next;
    end
    
    // Output assignments
    assign pm = pm_reg;
    assign ss = ss_reg;
    assign mm = mm_reg;
    assign hh = hh_reg;

endmodule