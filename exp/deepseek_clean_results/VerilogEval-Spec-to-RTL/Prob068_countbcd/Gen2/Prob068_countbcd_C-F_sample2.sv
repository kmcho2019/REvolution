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
    
    // Registered output to reduce switching
    reg [15:0] q_reg;
    assign q = q_reg;
    
    // Pre-compute all rollover conditions in parallel
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    // Generate enable signals using parallel logic
    assign ena[0] = ones_max;
    assign ena[1] = ones_max & tens_max;
    assign ena[2] = ones_max & tens_max & hundreds_max;
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            q_reg <= 16'd0;
        end
        else begin
            // Update ones digit every cycle
            if (ones_max) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Update tens digit only when ones rolls over
            if (ena[0]) begin
                if (tens_max) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Update hundreds digit only when tens rolls over
            if (ena[1]) begin
                if (hundreds_max) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Update thousands digit only when hundreds rolls over
            if (ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
            
            // Update output register only when needed
            q_reg <= {thousands, hundreds, tens, ones};
        end
    end

endmodule