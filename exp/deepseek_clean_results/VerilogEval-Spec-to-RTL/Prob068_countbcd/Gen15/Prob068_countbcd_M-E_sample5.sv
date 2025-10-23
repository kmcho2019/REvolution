module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // Digit registers
    reg [3:0] ones, tens, hundreds, thousands;
    assign q = {thousands, hundreds, tens, ones};
    
    // Pipeline registers
    reg [3:0] ones_next, tens_next, hundreds_next, thousands_next;
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    
    // Rollover conditions (calculated in parallel)
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Stage 1: Calculate next values and enable signals
    always @(*) begin
        // Default next values
        ones_next = ones + 4'd1;
        tens_next = tens;
        hundreds_next = hundreds;
        thousands_next = thousands;
        
        // Calculate enable signals
        ena_reg[0] = ones_rollover;
        ena_reg[1] = ones_rollover && tens_rollover;
        ena_reg[2] = ones_rollover && tens_rollover && hundreds_rollover;
        
        // Calculate digit rollovers
        if (ones_rollover) begin
            ones_next = 4'd0;
            if (tens_rollover) begin
                tens_next = 4'd0;
                if (hundreds_rollover) begin
                    hundreds_next = 4'd0;
                    thousands_next = (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
                end else begin
                    hundreds_next = hundreds + 4'd1;
                end
            end else begin
                tens_next = tens + 4'd1;
            end
        end
    end
    
    // Stage 2: Update registers
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
        end else begin
            ones <= ones_next;
            tens <= tens_next;
            hundreds <= hundreds_next;
            thousands <= thousands_next;
        end
    end

endmodule