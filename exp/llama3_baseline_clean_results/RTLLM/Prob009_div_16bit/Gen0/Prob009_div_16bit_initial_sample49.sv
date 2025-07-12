module div_16bit(
    input  [15:0] A, // 16-bit dividend
    input  [7:0] B,  // 8-bit divisor
    output [15:0] result, // 16-bit quotient
    output [15:0] odd   // 16-bit remainder
);

reg [15:0] a_reg; // register to hold the dividend
reg [7:0] b_reg;  // register to hold the divisor
reg [15:0] result_reg; // register to hold the quotient
reg [15:0] odd_reg;    // register to hold the remainder

// First always block: update registers with input values
always @(*) begin
    a_reg = A;
    b_reg = B;
end

// Second always block: perform division operation
always @(*) begin
    reg [15:0] temp; // temporary register to hold the remainder
    reg [7:0] div;    // register to hold the divisor
    reg [15:0] quot;  // register to hold the quotient
    reg [3:0] i;      // loop counter

    div = b_reg; // initialize divisor
    quot = 16'd0; // initialize quotient
    temp = a_reg; // initialize remainder

    for (i = 15; i >= 8; i = i - 1) begin // loop through dividend bits
        if (temp[15:8] >= div) begin // compare higher bits of dividend with divisor
            temp[15:8] = temp[15:8] - div; // update remainder
            quot[15 - i] = 1'd1; // update quotient
        end else begin
            temp[15:8] = temp[15:8]; // keep remainder unchanged
            quot[15 - i] = 1'd0; // update quotient
        end
        // shift remainder to the left and concatenate with the next bit of the dividend
        temp = {temp[15:8], temp[7], 7'd0};
    end

    // assign final quotient and remainder to output ports
    result_reg = quot;
    odd_reg = temp;

    // assign values to output ports
    result = result_reg;
    odd = odd_reg;
end

endmodule