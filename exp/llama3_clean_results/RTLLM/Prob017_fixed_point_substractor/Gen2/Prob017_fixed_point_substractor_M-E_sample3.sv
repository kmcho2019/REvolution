module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Sign detection stage
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Magnitude comparison stage
wire greater_a = (a[N-1] == 0 && b[N-1] ==) || (a[N-1] == b[N-1] && (a < b ? : 1));

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else if (sign_a ==  && sign_b == 1) begin
        // a is positive, b is negative
        if (greater_a) begin
            c = a + (~b + 1);
        end else begin
            c = (~b + 1) - a;
            c = -c;
        end
    end else begin
        // a is negative, b is positive
        if (greater_a) begin
            c = (~a + 1) - b;
            c = -c;
        end else begin
            c = b - (~a + 1);
        end
    end
    
    // Handle zero result
    if (c == 0) begin
        c = 0;
    end
end

endmodule