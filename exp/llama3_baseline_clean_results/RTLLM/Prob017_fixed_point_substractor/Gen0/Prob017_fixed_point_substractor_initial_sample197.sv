module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   logic [N-1:0] a,
    input   logic [N-1:0] b,
    output  logic [N-1:0] c
);

logic [N-1:0] res;

always_comb begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
            if (a < b) begin
                res = {1'b1, {(N-1){1'b0}}};
                res = ~res + 1;  // Two's complement of a
                res = res + b;
            end else begin
                res = a + ~b + 1;  // Add a and two's complement of b
            end
        end else begin  // a is negative, b is positive
            if (a < b) begin
                res = b - ~a + 1;  // Subtract two's complement of a from b
            end else begin
                res = ~b + 1;  // Two's complement of b
                res = res + a;
            end
        end
    end
    
    if (res == {N{1'b0}} || res == {N{1'b1}}) begin  // Handle zero result
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule