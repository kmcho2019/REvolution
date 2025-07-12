module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [15:0] q_reg;
    wire [3:0] next_ones, next_tens, next_hundreds, next_thousands;
    wire ones_overflow, tens_overflow, hundreds_overflow;
    
    // Registered output
    assign q = q_reg;
    
    // Overflow detection
    assign ones_overflow = (counter[3:0] == 4'd9);
    assign tens_overflow = (counter[7:4] == 4'd9);
    assign hundreds_overflow = (counter[11:8] == 4'd9);
    
    // Enable signals (simplified logic)
    assign ena[0] = ones_overflow;
    assign ena[1] = ones_overflow & tens_overflow;
    assign ena[2] = ones_overflow & tens_overflow & hundreds_overflow;
    
    // Next digit values (parallel computation)
    assign next_ones = (reset || ones_overflow) ? 4'd0 : (counter[3:0] + 4'd1);
    assign next_tens = (reset) ? 4'd0 :
                      (ones_overflow) ? (tens_overflow ? 4'd0 : (counter[7:4] + 4'd1)) : 
                      counter[7:4];
    assign next_hundreds = (reset) ? 4'd0 :
                          (ones_overflow & tens_overflow) ? 
                          (hundreds_overflow ? 4'd0 : (counter[11:8] + 4'd1)) : 
                          counter[11:8];
    assign next_thousands = (reset) ? 4'd0 :
                           (ones_overflow & tens_overflow & hundreds_overflow) ? 
                           ((counter[15:12] == 4'd9) ? 4'd0 : (counter[15:12] + 4'd1)) : 
                           counter[15:12];
    
    always @(posedge clk) begin
        counter <= {next_thousands, next_hundreds, next_tens, next_ones};
        q_reg <= counter;  // Registered output to reduce switching
    end

endmodule