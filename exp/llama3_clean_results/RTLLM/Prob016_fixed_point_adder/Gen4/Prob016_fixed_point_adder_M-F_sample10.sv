module fixed_point_adder #(parameter Q = 4, N = 16) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, perform addition
        c = a + b;
    end else begin // Different signs, perform subtraction
        if (a >= b) begin
            c = a - b;
        end else begin
            c = b - a;
        end
    end

    // Handle overflow
    if (c >= {1'b1, {N-1{1'b1}}}) begin // Positive overflow
        c = {1'b0, {N-1{1'b1}}}; // Saturate at maximum positive value
    end else if (c < {N{1'b0}}) begin // Negative overflow
        c = {1'b1, {N-1{1'b0}}}; // Saturate at minimum negative value
    end
end

endmodule