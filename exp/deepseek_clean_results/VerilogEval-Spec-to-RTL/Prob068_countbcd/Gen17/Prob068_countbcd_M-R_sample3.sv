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
    
    // Next digit values
    wire [3:0] next_ones = (ones == 4'd9) ? 4'd0 : ones + 4'd1;
    wire [3:0] next_tens = (ena[0]) ? ((tens == 4'd9) ? 4'd0 : tens + 4'd1) : tens;
    wire [3:0] next_hundreds = (ena[1]) ? ((hundreds == 4'd9) ? 4'd0 : hundreds + 4'd1) : hundreds;
    wire [3:0] next_thousands = (ena[2]) ? ((thousands == 4'd9) ? 4'd0 : thousands + 4'd1) : thousands;
    
    // Enable signals (combinational)
    assign ena[0] = (ones == 4'd9);
    assign ena[1] = (ones == 4'd9) && (tens == 4'd9);
    assign ena[2] = (ones == 4'd9) && (tens == 4'd9) && (hundreds == 4'd9);
    
    // Next counter value
    assign next_counter = {next_thousands, next_hundreds, next_tens, next_ones};
    
    // Counter update
    always @(posedge clk) begin
        if (reset)
            counter <= 16'd0;
        else
            counter <= next_counter;
    end
    
    assign q = counter;

endmodule