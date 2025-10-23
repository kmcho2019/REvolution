module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg pm_reg;
    reg [5:0] sec;      // 0-59 binary
    reg [5:0] min;      // 0-59 binary
    reg [3:0] hour;     // 1-12 binary
    
    // BCD conversion assignments
    assign ss = {sec[5:4], sec[3:0]};  // Direct mapping works for 0-59
    assign mm = {min[5:4], min[3:0]};  // Same as seconds
    
    // Hour BCD conversion (1-12)
    wire [3:0] hr_tens = (hour > 9) ? 4'd1 : 4'd0;
    wire [3:0] hr_ones = (hour > 9) ? hour - 4'd10 : hour;
    assign hh = {hr_tens, hr_ones};
    
    // State machine for time keeping
    always @(posedge clk) begin
        if (reset) begin
            sec <= 6'd0;
            min <= 6'd0;
            hour <= 4'd12;
            pm_reg <= 1'b0;
        end
        else if (ena) begin
            // Second increment
            if (sec == 6'd59) begin
                sec <= 6'd0;
                
                // Minute increment
                if (min == 6'd59) begin
                    min <= 6'd0;
                    
                    // Hour increment and PM toggle
                    if (hour == 4'd12) begin
                        hour <= 4'd1;
                    end
                    else begin
                        hour <= hour + 1;
                    end
                    
                    // Toggle PM at 11->12 transition
                    if (hour == 4'd11) begin
                        pm_reg <= ~pm_reg;
                    end
                end
                else begin
                    min <= min + 1;
                end
            end
            else begin
                sec <= sec + 1;
            end
        end
    end

    assign pm = pm_reg;

endmodule