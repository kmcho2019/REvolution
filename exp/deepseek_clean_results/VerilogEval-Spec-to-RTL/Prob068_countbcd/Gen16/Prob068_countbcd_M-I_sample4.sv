module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    assign q = counter;
    
    // Next value calculations
    wire ones_overflow = (ones == 4'd9);
    wire tens_overflow = (tens == 4'd9);
    wire hundreds_overflow = (hundreds == 4'd9);
    
    wire [3:0] next_ones = reset ? 4'd0 : (ones_overflow ? 4'd0 : ones + 1);
    wire [3:0] next_tens = reset ? 4'd0 : 
                          (ones_overflow ? (tens_overflow ? 4'd0 : tens + 1) : tens);
    wire [3:0] next_hundreds = reset ? 4'd0 : 
                              (ones_overflow & tens_overflow) ? 
                              (hundreds_overflow ? 4'd0 : hundreds + 1) : hundreds);
    wire [3:0] next_thousands = reset ? 4'd0 : 
                               (ones_overflow & tens_overflow & hundreds_overflow) ?
                               (thousands == 4'd9 ? 4'd0 : thousands + 1) : thousands);
    
    // Registered enable signals
    always @(posedge clk) begin
        if (reset) begin
            ena <= 3'b000;
        end else begin
            ena[0] <= ones_overflow;
            ena[1] <= ones_overflow & tens_overflow;
            ena[2] <= ones_overflow & tens_overflow & hundreds_overflow;
        end
    end
    
    // Counter update
    always @(posedge clk) begin
        counter[3:0] <= next_ones;
        counter[7:4] <= next_tens;
        counter[11:8] <= next_hundreds;
        counter[15:12] <= next_thousands;
    end

endmodule