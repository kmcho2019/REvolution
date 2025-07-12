module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Separate the integer and fractional parts of the input operands
    reg [N-Q-1:0] int_a, int_b;
    reg [Q-1:0] frac_a, frac_b;
    assign int_a = a[N-1:N-Q];
    assign frac_a = a[N-Q-1:0];
    assign int_b = b[N-1:N-Q];
    assign frac_b = b[N-Q-1:0];

    // Perform the addition or subtraction on the integer parts
    reg [N-Q:0] int_res;
    if (a[N-1] == b[N-1]) begin  // Same sign, add integer parts
        int_res = {1'b0, int_a} + {1'b0, int_b};
    end else begin  // Different signs, subtract integer parts
        if (int_a >= int_b) begin
            int_res = {1'b0, int_a} - {1'b0, int_b};
        end else begin
            int_res = {1'b0, int_b} - {1'b0, int_a};
        end
    end

    // Perform the addition or subtraction on the fractional parts
    reg [Q:0] frac_res;
    if (a[N-1] == b[N-1]) begin  // Same sign, add fractional parts
        frac_res = {1'b0, frac_a} + {1'b0, frac_b};
    end else begin  // Different signs, subtract fractional parts
        if (frac_a >= frac_b) begin
            frac_res = {1'b0, frac_a} - {1'b0, frac_b};
        end else begin
            frac_res = {1'b0, frac_b} - {1'b0, frac_a};
        end
    end

    // Combine the integer and fractional parts of the result
    res = {int_res[N-Q:1], frac_res[Q-1:0]};

    // Handle overflow by checking the most significant bit of the result
    if (res[N-1] != a[N-1]) begin
        res = (a[N-1] == 1'b0) ? {N-1{1'b1}} : {N-1{1'b0}};
    end
end

assign c = res;

endmodule