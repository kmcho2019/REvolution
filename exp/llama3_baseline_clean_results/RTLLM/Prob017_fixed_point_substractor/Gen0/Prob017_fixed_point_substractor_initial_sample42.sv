module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    // Check for zero result
    if (a == 0 && b == 0) begin
        res = 0;
    end else if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a positive, b negative
        if (a >= (b ^ {N{1'b1}} + 1)) begin // a is greater than b
            res = a + (b ^ {N{1'b1}} + 1);
        end else begin
            res = (b ^ {N{1'b1}} + 1) - a;
            res = res ^ {N{1'b1}} + 1; // Set negative sign
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a negative, b positive
        if ((a ^ {N{1'b1}} + 1) >= b) begin // a is greater than b in absolute value
            res = (a ^ {N{1'b1}} + 1) - b;
            res = res ^ {N{1'b1}} + 1; // Set negative sign
        end else begin
            res = b - (a ^ {N{1'b1}} + 1);
        end
    end
end

assign c = res;

endmodule