module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    // State registers
    reg pm_reg;
    reg [3:0] hour;         // Binary hour (1-12)
    reg [3:0] ss_tens, ss_ones;
    reg [3:0] mm_tens, mm_ones;
    
    // Next state signals
    wire [3:0] next_ss_ones = reset ? 4'd0 : 
                            (ena && (ss_ones == 4'd9)) ? 4'd0 : 
                            ena ? ss_ones + 1 : ss_ones;
    
    wire [3:0] next_ss_tens = reset ? 4'd0 : 
                             (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5)) ? 4'd0 : 
                             (ena && (ss_ones == 4'd9)) ? ss_tens + 1 : ss_tens;
    
    wire [3:0] next_mm_ones = reset ? 4'd0 : 
                            (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5) && (mm_ones == 4'd9)) ? 4'd0 : 
                            (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5)) ? mm_ones + 1 : mm_ones;
    
    wire [3:0] next_mm_tens = reset ? 4'd0 : 
                             (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5) && (mm_ones == 4'd9) && (mm_tens == 4'd5)) ? 4'd0 : 
                             (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5) && (mm_ones == 4'd9)) ? mm_tens + 1 : mm_tens;
    
    wire [3:0] next_hour = reset ? 4'd12 : 
                          (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5) && (mm_ones == 4'd9) && (mm_tens == 4'd5)) ? 
                          ((hour == 12) ? 4'd1 : hour + 1) : hour;
    
    wire next_pm = reset ? 1'b0 : 
                  (ena && (ss_ones == 4'd9) && (ss_tens == 4'd5) && (mm_ones == 4'd9) && (mm_tens == 4'd5) && (hour == 11)) ? 
                  ~pm_reg : pm_reg;

    // Register updates
    always @(posedge clk) begin
        ss_ones <= next_ss_ones;
        ss_tens <= next_ss_tens;
        mm_ones <= next_mm_ones;
        mm_tens <= next_mm_tens;
        hour <= next_hour;
        pm_reg <= next_pm;
    end

    // Output assignments
    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = (hour > 9) ? {4'd1, hour - 4'd10} : {4'd0, hour};
    assign pm = pm_reg;

endmodule