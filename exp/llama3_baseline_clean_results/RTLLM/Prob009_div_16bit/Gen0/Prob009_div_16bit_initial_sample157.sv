module div_16bit(
    input [15:0] A,  // 16-bit dividend
    input [7:0] B,   // 8-bit divisor
    output reg [15:0] result,  // 16-bit quotient
    output reg [15:0] odd     // 16-bit remainder
);

reg [15:0] a_reg;  // internal register for dividend
reg [7:0] b_reg;   // internal register for divisor

// First always block: update internal registers
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform division
always @(*) begin
    reg [15:0] temp_quotient;  // temporary quotient
    reg [15:0] temp_remainder; // temporary remainder
    reg [7:0] temp_divisor;    // temporary divisor
    reg [7:0] temp_dividend;   // temporary dividend
    
    temp_quotient = 16'd0;  // initialize quotient to 0
    temp_remainder = a_reg[15:8];  // initialize remainder with higher 8 bits of dividend
    
    for (int i = 15; i >= 8; i = i - 1) begin
        if (temp_remainder > b_reg) begin
            temp_quotient = {temp_quotient[14:0], 1'b1};  // set current quotient bit to 1
            temp_remainder = temp_remainder - b_reg;  // update remainder
        end else begin
            temp_quotient = {temp_quotient[14:0], 1'b0};  // set current quotient bit to 0
        end
        
        // shift in the next bit of the dividend
        if (i > 8) begin
            temp_remainder = {temp_remainder[6:0], a_reg[i-9]};
        end
    end
    
    result = temp_quotient;  // assign final quotient
    odd = {8'd0, temp_remainder};  // assign final remainder, zero-extend to 16 bits
end

endmodule