module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a, b) begin
    if (a >= 0 && b >= 0) begin
        res = a - b;
    end else if (a < 0 && b < 0) begin
        res = a - b;
    end else if (a >= 0 && b < 0) begin
        res = a + (~b + 1);
    end else begin
        res = (~a + 1) + b;
    end
    
    c = res; // Directly assign res to c, handling zero case implicitly
end

endmodule