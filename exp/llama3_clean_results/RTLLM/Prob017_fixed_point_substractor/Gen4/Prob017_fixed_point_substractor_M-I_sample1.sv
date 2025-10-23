module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Determine the signs of the input operands
reg same_sign;
always @(a or b) begin
    same_sign = (a[N-1] == b[N-1]);
end

// Perform subtraction or addition based on the signs
reg [N-1:0] result;
always @(same_sign or a or b) begin
    if (same_sign) begin
        result = a - b;
    end else begin
        if (a[N-1] == 1'b0) begin
            result = a + (~b + 1'b1);
        end else begin
            result = (~a + 1'b1) + b;
        end
    end
end

// Adjust the result to handle negative values and zero
always @(result) begin
    if (result == 0) begin
        c = {N{1'b0}};
    end else if (result[N-1] == 1'b1) begin
        c = ~result + 1'b1;
    end else begin
        c = result;
    end
end

endmodule