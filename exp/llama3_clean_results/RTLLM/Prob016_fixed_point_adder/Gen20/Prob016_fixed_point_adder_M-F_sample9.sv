module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    input clk,
    output reg [N-1:0] c
);

reg [N-1:0] res;

always @(posedge clk) begin
    if (a[N-1] == b[N-1]) begin
        // Both positive or both negative, add absolute values
        res = a + b;
    end else begin
        // One positive and one negative, subtract absolute values
        if (a > b) begin
            // a is greater, result is a - b
            res = a - b;
        end else begin
            // b is greater, result is b - a
            res = b - a;
        end
    end
    
    // Overflow handling
    if (res[N-1] && ~a[N-1] && ~b[N-1]) begin
        // Positive overflow
        c <= {1'b1, {(N-1){1'b1}}};
    end else if (~res[N-1] && a[N-1] && b[N-1]) begin
        // Negative overflow
        c <= {1'b1, {(N-1){1'b0}}};
    end else begin
        c <= res;
    end
end

endmodule