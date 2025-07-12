module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Calculate the sum or difference based on the signs of a and b
reg [N-1:0] res;
always @(*) begin
    if (a_sign == b_sign) begin
        // Add absolute values
        res = a + b;
    end else begin
        // Subtract smaller absolute value from larger one
        if (a > b) begin
            res = a - (~b + 1'b1);
        end else begin
            res = (~a + 1'b1) - b;
        end
    end
    
    // Handle overflow
    if (res[N-1]!= a_sign && res[N-1]!= b_sign) begin
        if (a_sign == 1'b1) begin
            c = {N{1'b1}};
        end else begin
            c = {N{1'b0}};
        end
    end else begin
        c = res;
    end
end

endmodule