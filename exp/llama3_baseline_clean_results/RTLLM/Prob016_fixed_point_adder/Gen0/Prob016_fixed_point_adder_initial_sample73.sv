module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // Internal register for storing the result

always @(*) begin
    // Check if the MSBs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        // MSB of the result is set to match the MSBs of a and b
        if (res[N-1]!= a[N-1]) begin
            // Handle overflow by saturating the result
            if (a[N-1] == 1'b0) begin
                res = {N{1'b1}};
            end else begin
                res = {N{1'b0}};
            end
        end
    end else begin
        // Absolute value subtraction
        if (a >= b) begin
            res = a - b;
            // MSB of the result is set to 0 (positive)
            if (res[N-1] == 1'b1) begin
                // Handle underflow by saturating the result
                res = {N{1'b0}};
            end
        end else begin
            res = b - a;
            // MSB of the result is set according to whether the result is zero or negative
            if (res[N-1] == 1'b0 && res!= {N{1'b0}}) begin
                // Handle underflow by saturating the result
                res = {N{1'b0}};
            end
        end
    end
end

assign c = res;  // Assign the result to the output port

endmodule