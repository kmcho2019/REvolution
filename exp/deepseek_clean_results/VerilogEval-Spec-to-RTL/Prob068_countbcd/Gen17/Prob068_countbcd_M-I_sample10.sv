module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] ones, tens, hundreds, thousands;
    reg [2:0] ena_reg;
    
    // Output assignments
    assign q = {thousands, hundreds, tens, ones};
    assign ena = ena_reg;
    
    // Shared comparison signals
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b0;
        end else begin
            // Ones digit always increments
            ones <= ones_max ? 4'd0 : ones + 4'd1;
            
            // Enable signals (registered to break critical path)
            ena_reg[0] <= ones_max;
            ena_reg[1] <= ones_max & tens_max;
            ena_reg[2] <= ones_max & tens_max & hundreds_max;
            
            // Other digits increment only when enabled
            if (ena_reg[0]) tens <= tens_max ? 4'd0 : tens + 4'd1;
            if (ena_reg[1]) hundreds <= hundreds_max ? 4'd0 : hundreds + 4'd1;
            if (ena_reg[2]) thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
        end
    end

endmodule