module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit [3:0];  // digits: digit[0] = ones, digit[1] = tens, etc.
    wire [3:0] next_digit [3:0];
    wire [3:0] carry_in;
    
    // Assign outputs
    assign q = {digit[3], digit[2], digit[1], digit[0]};
    assign ena[0] = (digit[0] == 4'd9);
    assign ena[1] = (digit[1] == 4'd9) & ena[0];
    assign ena[2] = (digit[2] == 4'd9) & ena[1];
    
    // Carry lookahead logic
    assign carry_in[0] = 1'b1;  // Always increment ones digit
    assign carry_in[1] = (digit[0] == 4'd9);
    assign carry_in[2] = (digit[1] == 4'd9) & carry_in[1];
    assign carry_in[3] = (digit[2] == 4'd9) & carry_in[2];
    
    // Next digit calculation (parallel processing)
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : digit_logic
            assign next_digit[i] = (reset) ? 4'd0 : 
                                 (carry_in[i]) ? 
                                 ((digit[i] == 4'd9) ? 4'd0 : digit[i] + 4'd1) : 
                                 digit[i];
        end
    endgenerate
    
    // Update registers
    always @(posedge clk) begin
        digit[0] <= next_digit[0];
        digit[1] <= next_digit[1];
        digit[2] <= next_digit[2];
        digit[3] <= next_digit[3];
    end

endmodule