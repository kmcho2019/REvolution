module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    
    // Parallel rollover detection
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 3'b0;
        end else begin
            ena_reg[0] <= ones_rollover;
            ena_reg[1] <= ones_rollover & tens_rollover;
            ena_reg[2] <= ones_rollover & tens_rollover & hundreds_rollover;
        end
    end
    assign ena = ena_reg;
    
    // Unified digit increment logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            // Ones digit
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 4'd1;
            
            // Tens digit
            if (ena_reg[0])
                counter[7:4] <= (counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 4'd1;
            
            // Hundreds digit
            if (ena_reg[1])
                counter[11:8] <= (counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 4'd1;
            
            // Thousands digit
            if (ena_reg[2])
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 4'd1;
        end
    end
    
    assign q = counter;

endmodule