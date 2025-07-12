module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    // Rollover signals for each digit
    wire ones_rollover = (ones == 4'd9);
    wire tens_rollover = (tens == 4'd9);
    wire hundreds_rollover = (hundreds == 4'd9);
    
    // Enable signals
    assign ena[0] = ones_rollover;
    assign ena[1] = ones_rollover & tens_rollover;
    assign ena[2] = ones_rollover & tens_rollover & hundreds_rollover;
    
    // Next value calculation
    wire [15:0] next_counter;
    assign next_counter = reset ? 16'd0 : 
        {
            // Thousands digit
            (ena[2] ? (thousands == 4'd9 ? 4'd0 : thousands + 4'd1) : thousands),
            // Hundreds digit
            (ena[1] ? (hundreds == 4'd9 ? 4'd0 : hundreds + 4'd1) : hundreds),
            // Tens digit
            (ena[0] ? (tens == 4'd9 ? 4'd0 : tens + 4'd1) : tens),
            // Ones digit
            (ones == 4'd9 ? 4'd0 : ones + 4'd1)
        };
    
    assign q = counter;
    
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule