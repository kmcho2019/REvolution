module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    assign q = counter;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena <= 3'b0;
        end else begin
            // Default case - no rollover
            ena <= 3'b0;
            
            // Ones digit always increments
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                ena[0] <= 1'b1;
                
                // Tens digit increments if ones rolls over
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    ena[1] <= 1'b1;
                    
                    // Hundreds digit increments if tens rolls over
                    if (counter[11:8] == 4'd9) begin
                        counter[11:8] <= 4'd0;
                        ena[2] <= 1'b1;
                        
                        // Thousands digit increments if hundreds rolls over
                        if (counter[15:12] != 4'd9)
                            counter[15:12] <= counter[15:12] + 1;
                        else
                            counter[15:12] <= 4'd0;
                    end else begin
                        counter[11:8] <= counter[11:8] + 1;
                    end
                end else begin
                    counter[7:4] <= counter[7:4] + 1;
                end
            end else begin
                counter[3:0] <= counter[3:0] + 1;
            end
        end
    end

endmodule