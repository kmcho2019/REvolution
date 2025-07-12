module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    // One-hot encoded BCD digits (10 bits per digit)
    reg [9:0] digit0;  // Ones
    reg [9:0] digit1;  // Tens
    reg [9:0] digit2;  // Hundreds
    reg [9:0] digit3;  // Thousands
    
    // Binary outputs
    assign q[3:0] = 
        digit0[0] ? 4'd0 : digit0[1] ? 4'd1 : digit0[2] ? 4'd2 :
        digit0[3] ? 4'd3 : digit0[4] ? 4'd4 : digit0[5] ? 4'd5 :
        digit0[6] ? 4'd6 : digit0[7] ? 4'd7 : digit0[8] ? 4'd8 : 4'd9;
    
    assign q[7:4] = 
        digit1[0] ? 4'd0 : digit1[1] ? 4'd1 : digit1[2] ? 4'd2 :
        digit1[3] ? 4'd3 : digit1[4] ? 4'd4 : digit1[5] ? 4'd5 :
        digit1[6] ? 4'd6 : digit1[7] ? 4'd7 : digit1[8] ? 4'd8 : 4'd9;
    
    assign q[11:8] = 
        digit2[0] ? 4'd0 : digit2[1] ? 4'd1 : digit2[2] ? 4'd2 :
        digit2[3] ? 4'd3 : digit2[4] ? 4'd4 : digit2[5] ? 4'd5 :
        digit2[6] ? 4'd6 : digit2[7] ? 4'd7 : digit2[8] ? 4'd8 : 4'd9;
    
    assign q[15:12] = 
        digit3[0] ? 4'd0 : digit3[1] ? 4'd1 : digit3[2] ? 4'd2 :
        digit3[3] ? 4'd3 : digit3[4] ? 4'd4 : digit3[5] ? 4'd5 :
        digit3[6] ? 4'd6 : digit3[7] ? 4'd7 : digit3[8] ? 4'd8 : 4'd9;
    
    // Enable signals (detect transition from 9 to 0)
    assign ena[0] = digit0[9] & (digit0[0] | reset);
    assign ena[1] = digit1[9] & (digit1[0] | reset);
    assign ena[2] = digit2[9] & (digit2[0] | reset);
    
    // Shared increment logic
    function [9:0] increment_digit;
        input [9:0] current;
        begin
            increment_digit = {current[8:0], current[9]};
        end
    endfunction
    
    always @(posedge clk) begin
        if (reset) begin
            digit0 <= 10'b0000000001;  // 0
            digit1 <= 10'b0000000001;  // 0
            digit2 <= 10'b0000000001;  // 0
            digit3 <= 10'b0000000001;  // 0
        end else begin
            // Always increment ones digit
            digit0 <= increment_digit(digit0);
            
            // Conditionally increment other digits
            if (digit0[9]) begin
                digit1 <= increment_digit(digit1);
                
                if (digit1[9]) begin
                    digit2 <= increment_digit(digit2);
                    
                    if (digit2[9]) begin
                        digit3 <= increment_digit(digit3);
                    end
                end
            end
        end
    end

endmodule