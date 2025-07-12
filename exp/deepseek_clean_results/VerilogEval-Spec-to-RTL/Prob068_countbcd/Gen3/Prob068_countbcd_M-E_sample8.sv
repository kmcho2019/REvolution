module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [0:3];  // Array for digits: digits[0]=ones, digits[1]=tens, etc.
    wire [3:0] next_digits [0:3];
    wire [3:0] carry;
    
    // Generate carry signals in parallel
    assign carry[0] = (digits[0] == 4'd9);
    assign carry[1] = (digits[1] == 4'd9) & carry[0];
    assign carry[2] = (digits[2] == 4'd9) & carry[1];
    assign carry[3] = (digits[3] == 4'd9) & carry[2];
    
    // Generate enable signals
    assign ena = {carry[3], carry[2], carry[1]};
    
    // Next digit calculation (parallel processing)
    assign next_digits[0] = reset ? 4'd0 : 
                          (digits[0] == 4'd9) ? 4'd0 : digits[0] + 4'd1;
    
    assign next_digits[1] = reset ? 4'd0 : 
                          carry[0] ? ((digits[1] == 4'd9) ? 4'd0 : digits[1] + 4'd1) : 
                          digits[1];
    
    assign next_digits[2] = reset ? 4'd0 : 
                          carry[1] ? ((digits[2] == 4'd9) ? 4'd0 : digits[2] + 4'd1) : 
                          digits[2];
    
    assign next_digits[3] = reset ? 4'd0 : 
                          carry[2] ? ((digits[3] == 4'd9) ? 4'd0 : digits[3] + 4'd1) : 
                          digits[3];
    
    // Update registers
    always @(posedge clk) begin
        digits[0] <= next_digits[0];
        digits[1] <= next_digits[1];
        digits[2] <= next_digits[2];
        digits[3] <= next_digits[3];
    end
    
    // Output concatenation
    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule