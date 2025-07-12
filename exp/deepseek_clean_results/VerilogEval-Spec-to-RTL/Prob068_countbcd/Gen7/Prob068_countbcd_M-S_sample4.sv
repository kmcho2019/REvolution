module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Rollover conditions for enable signals
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover && tens_rollover;
    assign ena[2] = ones_rollover && tens_rollover && hundreds_rollover;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Ones digit always increments
            counter[3:0] <= (counter[3:0] == 4'd9) ? 4'd0 : counter[3:0] + 1;
            
            // Tens digit increments when ones rolls over
            if (ones_rollover) begin
                counter[7:4] <= (counter[7:4] == 4'd9) ? 4'd0 : counter[7:4] + 1;
            end
            
            // Hundreds digit increments when tens rolls over
            if (ones_rollover && tens_rollover) begin
                counter[11:8] <= (counter[11:8] == 4'd9) ? 4'd0 : counter[11:8] + 1;
            end
            
            // Thousands digit increments when hundreds rolls over
            if (ones_rollover && tens_rollover && hundreds_rollover) begin
                counter[15:12] <= (counter[15:12] == 4'd9) ? 4'd0 : counter[15:12] + 1;
            end
        end
    end

endmodule