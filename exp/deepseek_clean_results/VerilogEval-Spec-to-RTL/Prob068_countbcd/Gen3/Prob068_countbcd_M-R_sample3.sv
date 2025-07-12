module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    
    // Extract digits
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    // Parallel enable logic
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    assign ena[0] = ones_max;
    assign ena[1] = ones_max & tens_max;
    assign ena[2] = ones_max & tens_max & hundreds_max;
    
    // Next value calculation
    wire [3:0] next_ones = reset ? 4'd0 : (ones_max ? 4'd0 : ones + 4'd1);
    wire [3:0] next_tens = reset ? 4'd0 : (ena[0] ? (tens_max ? 4'd0 : tens + 4'd1) : tens);
    wire [3:0] next_hundreds = reset ? 4'd0 : (ena[1] ? (hundreds_max ? 4'd0 : hundreds + 4'd1) : hundreds);
    wire [3:0] next_thousands = reset ? 4'd0 : (ena[2] ? (thousands == 4'd9 ? 4'd0 : thousands + 4'd1) : thousands);
    
    assign q = counter;
    
    always @(posedge clk) begin
        counter <= {next_thousands, next_hundreds, next_tens, next_ones};
    end

endmodule