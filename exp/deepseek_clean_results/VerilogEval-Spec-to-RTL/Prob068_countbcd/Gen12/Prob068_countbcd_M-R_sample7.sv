module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    wire [15:0] next_counter;
    
    // Current digit values
    wire [3:0] ones = counter[3:0];
    wire [3:0] tens = counter[7:4];
    wire [3:0] hundreds = counter[11:8];
    wire [3:0] thousands = counter[15:12];
    
    // Rollover conditions (enable signals)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (tens == 4'd9) & ena[0];
    assign ena[2] = (hundreds == 4'd9) & ena[1];
    
    // Next digit values
    wire [3:0] next_ones = reset ? 4'd0 : 
                          (ones == 4'd9) ? 4'd0 : ones + 4'd1;
                          
    wire [3:0] next_tens = reset ? 4'd0 : 
                          (ena[0] && tens == 4'd9) ? 4'd0 : 
                          ena[0] ? tens + 4'd1 : tens;
                          
    wire [3:0] next_hundreds = reset ? 4'd0 : 
                              (ena[1] && hundreds == 4'd9) ? 4'd0 : 
                              ena[1] ? hundreds + 4'd1 : hundreds;
                              
    wire [3:0] next_thousands = reset ? 4'd0 : 
                               (ena[2] && thousands == 4'd9) ? 4'd0 : 
                               ena[2] ? thousands + 4'd1 : thousands;
    
    // Combine next digit values
    assign next_counter = {next_thousands, next_hundreds, next_tens, next_ones};
    assign q = counter;
    
    // Sequential update
    always @(posedge clk) begin
        counter <= next_counter;
    end

endmodule