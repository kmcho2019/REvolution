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
    
    // Parallel enable calculation
    wire ones_max = (ones == 4'd9);
    wire tens_max = (tens == 4'd9);
    wire hundreds_max = (hundreds == 4'd9);
    
    assign ena[0] = ones_max;
    assign ena[1] = tens_max & ones_max;
    assign ena[2] = hundreds_max & tens_max & ones_max;
    
    // Next value calculation (parallel processing)
    wire [3:0] next_ones = reset ? 4'd0 : (ones + 4'd1) % 4'd10;
    wire [3:0] next_tens = reset ? 4'd0 : 
                         (ena[0] ? (tens + 4'd1) % 4'd10 : tens);
    wire [3:0] next_hundreds = reset ? 4'd0 : 
                             (ena[1] ? (hundreds + 4'd1) % 4'd10 : hundreds);
    wire [3:0] next_thousands = reset ? 4'd0 : 
                              (ena[2] ? (thousands + 4'd1) % 4'd10 : thousands);
    
    assign q = counter;
    
    always @(posedge clk) begin
        counter <= {next_thousands, next_hundreds, next_tens, next_ones};
    end

endmodule