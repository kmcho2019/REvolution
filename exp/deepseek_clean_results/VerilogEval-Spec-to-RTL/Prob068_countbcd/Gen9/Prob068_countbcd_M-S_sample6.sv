module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Enable signals are just current digit = 9
    assign ena[0] = (counter[3:0] == 4'd9;   // Tens enable
    assign ena[1] = (counter[7:4] == 4'd9);  // Hundreds enable
    assign ena[2] = (counter[11:8] == 4'd9); // Thousands enable
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Ones digit (always increments)
            if (counter[3:0] == 4'd9)
                counter[3:0] <= 4'd0;
            else
                counter[3:0] <= counter[3:0] + 1;
            
            // Tens digit (increments when ones rolls over)
            if (ena[0]) begin
                if (counter[7:4] == 4'd9)
                    counter[7:4] <= 4'd0;
                else
                    counter[7:4] <= counter[7:4] + 1;
            end
            
            // Hundreds digit (increments when tens rolls over)
            if (ena[0] && ena[1]) begin
                if (counter[11:8] == 4'd9)
                    counter[11:8] <= 4'd0;
                else
                    counter[11:8] <= counter[11:8] + 1;
            end
            
            // Thousands digit (increments when hundreds rolls over)
            if (ena[0] && ena[1] && ena[2]) begin
                if (counter[15:12] == 4'd9)
                    counter[15:12] <= 4'd0;
                else
                    counter[15:12] <= counter[15:12] + 1;
            end
        end
    end

endmodule