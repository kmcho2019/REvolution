module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;
reg [N-1:0] temp_res;

// Determine the sign of the result
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Both positive or both negative, add absolute values
        temp_res = a + b;
    end else begin
        // One positive and one negative, subtract absolute values
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            temp_res = a + (~b + 1);
        end else begin
            // a is negative, b is positive
            temp_res = (~a + 1) + b;
        end
    end

    // Saturate the result to handle overflows
    if (temp_res[N-1] && ~a[N-1] && ~b[N-1]) begin
        // Positive overflow
        res = {1'b1, {(N-1){1'b1}}};
    end else if (~temp_res[N-1] && a[N-1] && b[N-1]) begin
        // Negative overflow
        res = {1'b1, {(N-1){1'b0}}};
    end else begin
        // No overflow
        res = temp_res;
    end
end

// Pipeline stage to reduce critical path
always @(posedge clk) begin
    c <= res;
end

endmodule