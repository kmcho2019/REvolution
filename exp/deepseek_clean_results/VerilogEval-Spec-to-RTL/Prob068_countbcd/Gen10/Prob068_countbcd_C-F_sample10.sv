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
    reg [15:0] q_reg;
    
    // Registered output
    assign q = q_reg;
    
    // Shared comparator signals
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    // Efficient enable signals
    assign ena[0] = ones_max;                      // tens enable
    assign ena[1] = ones_max & tens_max;           // hundreds enable
    assign ena[2] = ones_max & tens_max & hundreds_max; // thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
            hundreds <= 4'd0;
            thousands <= 4'd0;
            q_reg <= 16'd0;
        end
        else begin
            // Increment ones digit
            if (ones_max) begin
                ones <= 4'd0;
                // Increment tens if ones overflows
                if (tens_max) begin
                    tens <= 4'd0;
                    // Increment hundreds if tens overflows
                    if (hundreds_max) begin
                        hundreds <= 4'd0;
                        // Increment thousands if hundreds overflows
                        thousands <= (thousands == 4'd9) ? 4'd0 : thousands + 1;
                    end
                    else begin
                        hundreds <= hundreds + 1;
                    end
                end
                else begin
                    tens <= tens + 1;
                end
            end
            else begin
                ones <= ones + 1;
            end
            
            // Update registered output
            q_reg <= {thousands, hundreds, tens, ones};
        end
    end

endmodule