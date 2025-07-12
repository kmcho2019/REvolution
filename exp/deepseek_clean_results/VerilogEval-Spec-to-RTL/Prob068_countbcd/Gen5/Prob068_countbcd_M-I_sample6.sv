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
    
    // Shared rollover signals
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Registered enable signals
    reg [2:0] ena_reg;
    assign ena = ena_reg;
    
    // Combine digits into output
    assign q = {thousands, hundreds, tens, ones};
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            ena_reg <= 3'b0;
        end else begin
            // Update enable signals first
            ena_reg[0] <= ones_rollover;
            ena_reg[1] <= ones_rollover & tens_rollover;
            ena_reg[2] <= ones_rollover & tens_rollover & hundreds_rollover;
            
            // Increment digits with rollover
            ones <= ones_rollover ? 4'd0 : ones + 4'd1;
            
            if (ena_reg[0]) begin
                tens <= tens_rollover ? 4'd0 : tens + 4'd1;
            end
            
            if (ena_reg[1]) begin
                hundreds <= hundreds_rollover ? 4'd0 : hundreds + 4'd1;
            end
            
            if (ena_reg[2]) begin
                thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

endmodule