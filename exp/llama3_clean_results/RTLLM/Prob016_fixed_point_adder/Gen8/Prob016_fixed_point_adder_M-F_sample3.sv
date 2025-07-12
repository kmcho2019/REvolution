module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    // Determine signs of operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Perform addition or subtraction based on signs
    reg [N-1:0] result;
    if (sign_a == sign_b) begin
        // Addition of absolute values
        result = (a[N-1] == 1'b0) ? (a + b) : ((~a + 1) + (~b + 1));
    end else begin
        // Subtraction of absolute values
        if ((~a + 1) > (~b + 1)) begin
            result = (~a + 1) - (~b + 1);
        end else begin
            result = (~b + 1) - (~a + 1);
        end
    end

    // Handle overflow
    if (result[N-1] != sign_a && sign_a == 1'b0) begin // Overflow
        c = {N{1'b1}};
    end else if (result[N-1] != sign_a && sign_a == 1'b1) begin // Underflow
        c = {N{1'b0}};
    end else begin
        c = result;
    end
end

endmodule