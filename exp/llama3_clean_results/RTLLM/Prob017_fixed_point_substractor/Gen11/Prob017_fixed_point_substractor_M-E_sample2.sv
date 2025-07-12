module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;
reg [N-1:0] sign_a, sign_b;
reg [N-1:0] abs_a, abs_b;

// Stage 1: Sign Determination
always @(a, b) begin
    sign_a = (a[N-1] == 1'b0) ? {N{1'b0}} : {N{1'b1}};
    sign_b = (b[N-1] == 1'b0) ? {N{1'b0}} : {N{1'b1}};
    abs_a = (a[N-1] == 1'b0) ? a : (~a + 1'b1);
    abs_b = (b[N-1] == 1'b0) ? b : (~b + 1'b1);
end

// Stage 2: Arithmetic Unit
always @(abs_a, abs_b, sign_a, sign_b) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = (a >= b) ? a - b : b - a;
    end else begin
        // Different sign addition
        res = (abs_a >= abs_b) ? abs_a + abs_b : -(abs_b + abs_a);
    end
end

// Stage 3: Precision Adjustment Unit
always @(res) begin
    if (res == 0) begin
        c = {N{1'b0}};
    end else if (res[N-1] == 1'b1) begin
        c = -res;
    end else begin
        c = res;
    end
end

endmodule