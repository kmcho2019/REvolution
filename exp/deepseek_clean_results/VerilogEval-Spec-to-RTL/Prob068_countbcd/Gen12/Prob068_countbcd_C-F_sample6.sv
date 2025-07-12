module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    assign q = counter;
    assign ena = ena_reg;
    
    // Rollover conditions (parallel evaluation)
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena_reg <= 3'b0;
        end
        else begin
            // Update enable signals first (registered to break critical path)
            ena_reg[0] <= ones_rollover;
            ena_reg[1] <= tens_rollover & ones_rollover;
            ena_reg[2] <= hundreds_rollover & tens_rollover & ones_rollover;
            
            // Increment logic (only evaluate digits that might change)
            // Ones digit (always increments)
            if (ones_rollover)
                counter[3:0] <= 4'd0;
            else
                counter[3:0] <= counter[3:0] + 4'd1;
            
            // Tens digit (only when ones rolls over)
            if (ones_rollover) begin
                if (tens_rollover)
                    counter[7:4] <= 4'd0;
                else
                    counter[7:4] <= counter[7:4] + 4'd1;
            end
            
            // Hundreds digit (only when tens rolls over)
            if (ena_reg[1]) begin
                if (hundreds_rollover)
                    counter[11:8] <= 4'd0;
                else
                    counter[11:8] <= counter[11:8] + 4'd1;
            end
            
            // Thousands digit (only when hundreds rolls over)
            if (ena_reg[2]) begin
                if (counter[15:12] == 4'd9)
                    counter[15:12] <= 4'd0;
                else
                    counter[15:12] <= counter[15:12] + 4'd1;
            end
        end
    end

endmodule