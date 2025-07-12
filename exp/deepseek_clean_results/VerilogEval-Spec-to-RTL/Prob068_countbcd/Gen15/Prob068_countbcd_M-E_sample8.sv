module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digits [0:3];  // [0]=ones, [1]=tens, [2]=hundreds, [3]=thousands
    wire [3:0] overflow = {digits[3] == 4'd9, digits[2] == 4'd9, 
                          digits[1] == 4'd9, digits[0] == 4'd9};
    
    // Enable signals (independent overflow detection)
    assign ena[0] = overflow[0];
    assign ena[1] = overflow[0] & overflow[1];
    assign ena[2] = overflow[0] & overflow[1] & overflow[2];

    // Next digit values (computed independently)
    wire [3:0] next_digits [0:3];
    assign next_digits[0] = reset ? 4'd0 : 
                           (digits[0] + 1'b1) % 10;
    assign next_digits[1] = reset ? 4'd0 : 
                           overflow[0] ? ((digits[1] + 1'b1) % 10) : digits[1];
    assign next_digits[2] = reset ? 4'd0 : 
                           (overflow[0] & overflow[1]) ? ((digits[2] + 1'b1) % 10) : digits[2];
    assign next_digits[3] = reset ? 4'd0 : 
                           (overflow[0] & overflow[1] & overflow[2]) ? 
                           ((digits[3] + 1'b1) % 10) : digits[3];

    always @(posedge clk) begin
        digits[0] <= next_digits[0];
        digits[1] <= next_digits[1];
        digits[2] <= next_digits[2];
        digits[3] <= next_digits[3];
    end

    assign q = {digits[3], digits[2], digits[1], digits[0]};

endmodule