module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    assign q = counter;
    
    // Parallel rollover detection
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    // Parallel enable generation
    assign ena[0] = ones_rollover;
    assign ena[1] = tens_rollover & ones_rollover;
    assign ena[2] = hundreds_rollover & tens_rollover & ones_rollover;
    
    // Clock gating signals
    wire tens_inc = ena[0];
    wire hundreds_inc = ena[1];
    wire thousands_inc = ena[2];
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end
        else begin
            // Always increment ones digit
            if (ones_rollover) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
            
            // Conditional tens digit increment
            if (tens_inc) begin
                if (tens_rollover) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end
            
            // Conditional hundreds digit increment
            if (hundreds_inc) begin
                if (hundreds_rollover) begin
                    counter[11:8] <= 4'd0;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                end
            end
            
            // Conditional thousands digit increment
            if (thousands_inc) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
        end
    end

endmodule