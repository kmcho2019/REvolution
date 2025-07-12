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
    
    // Common expressions for enable logic
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    // Registered enable signals
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    
    // Compute next enables in parallel
    wire [2:0] next_ena;
    assign next_ena[0] = ones_max;
    assign next_ena[1] = ones_max & tens_max;
    assign next_ena[2] = ones_max & tens_max & hundreds_max;
    
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
            // Register enable signals
            ena_reg <= next_ena;
            
            // Update ones digit every cycle
            if (ones == 4'd9) begin
                ones <= 4'd0;
            end else begin
                ones <= ones + 4'd1;
            end
            
            // Update tens digit only when needed
            if (next_ena[0]) begin
                if (tens == 4'd9) begin
                    tens <= 4'd0;
                end else begin
                    tens <= tens + 4'd1;
                end
            end
            
            // Update hundreds digit only when needed
            if (next_ena[1]) begin
                if (hundreds == 4'd9) begin
                    hundreds <= 4'd0;
                end else begin
                    hundreds <= hundreds + 4'd1;
                end
            end
            
            // Update thousands digit only when needed
            if (next_ena[2]) begin
                if (thousands == 4'd9) begin
                    thousands <= 4'd0;
                end else begin
                    thousands <= thousands + 4'd1;
                end
            end
        end
    end

endmodule