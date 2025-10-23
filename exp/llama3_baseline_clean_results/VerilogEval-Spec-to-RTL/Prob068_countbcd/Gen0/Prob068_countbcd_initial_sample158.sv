module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] ones, tens, hundreds, thousands;
assign q = {thousands, hundreds, tens, ones};

always @(posedge clk) begin
    if(reset) begin
        ones <= 0;
        tens <= 0;
        hundreds <= 0;
        thousands <= 0;
    end else begin
        reg [3:0] next_ones, next_tens, next_hundreds, next_thousands;
        reg [2:0] next_ena;
        
        // calculate next state
        next_ones = ones + 1;
        next_tens = tens;
        next_hundreds = hundreds;
        next_thousands = thousands;
        next_ena = 3'b000;
        
        if(next_ones == 10) begin
            next_ones = 0;
            next_tens = tens + 1;
            next_ena[0] = 1;
        end
        
        if(next_tens == 10) begin
            next_tens = 0;
            next_hundreds = hundreds + 1;
            next_ena[1] = 1;
        end
        
        if(next_hundreds == 10) begin
            next_hundreds = 0;
            next_thousands = thousands + 1;
            next_ena[2] = 1;
        end
        
        // update state
        ones <= next_ones;
        tens <= next_tens;
        hundreds <= next_hundreds;
        thousands <= next_thousands;
        ena <= next_ena;
    end
end

endmodule