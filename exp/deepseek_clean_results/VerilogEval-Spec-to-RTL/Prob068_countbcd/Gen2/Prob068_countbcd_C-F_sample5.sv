module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;
    reg [3:0] thousands;
    
    // Registered enable signals
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    
    // Pre-compute rollover conditions in parallel
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Clock gating signals
    wire tens_clk_en = ones_rollover;
    wire hundreds_clk_en = ones_rollover & tens_rollover;
    wire thousands_clk_en = ones_rollover & tens_rollover & hundreds_rollover;
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b0;
        end
        else begin
            // Update enable signals first
            ena_reg[0] <= ones_rollover;
            ena_reg[1] <= ones_rollover & tens_rollover;
            ena_reg[2] <= ones_rollover & tens_rollover & hundreds_rollover;
            
            // Always update ones digit
            if (ones_rollover) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Update tens only when needed (clock gating)
            if (tens_clk_en) begin
                if (tens_rollover) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Update hundreds only when needed
            if (hundreds_clk_en) begin
                if (hundreds_rollover) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Update thousands only when needed
            if (thousands_clk_en) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule