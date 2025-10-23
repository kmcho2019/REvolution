module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] bcd_counter;
    reg [2:0] ena_reg;
    
    // Extract digits from combined register
    wire [3:0] ones = bcd_counter[3:0];
    wire [3:0] tens = bcd_counter[7:4];
    wire [3:0] hundreds = bcd_counter[11:8];
    wire [3:0] thousands = bcd_counter[15:12];
    
    // Parallel enable logic
    assign ena = ena_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            bcd_counter <= 16'd0;
            ena_reg <= 3'b0;
        end
        else begin
            // Calculate enable signals in parallel
            ena_reg[0] <= (ones == 4'd9);
            ena_reg[1] <= (tens == 4'd9) & (ones == 4'd9);
            ena_reg[2] <= (hundreds == 4'd9) & (tens == 4'd9) & (ones == 4'd9);
            
            // Update counter
            bcd_counter[3:0] <= (ones == 4'd9) ? 4'd0 : ones + 4'd1;
            
            if (ena_reg[0]) begin
                bcd_counter[7:4] <= (tens == 4'd9) ? 4'd0 : tens + 4'd1;
            end
            
            if (ena_reg[1]) begin
                bcd_counter[11:8] <= (hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1;
            end
            
            if (ena_reg[2]) begin
                bcd_counter[15:12] <= (thousands == 4'd9) ? 4'd0 : thousands + 4'd1;
            end
        end
    end

    assign q = bcd_counter;

endmodule