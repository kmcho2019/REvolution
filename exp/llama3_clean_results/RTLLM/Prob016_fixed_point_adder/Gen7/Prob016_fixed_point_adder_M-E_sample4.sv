module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Dedicated absolute value calculation block
reg [N-1:0] abs_a;
reg [N-1:0] abs_b;
always @(*) begin
    abs_a = (a[N-1] == 1'b0) ? a : ~a + 1;
    abs_b = (b[N-1] == 1'b0) ? b : ~b + 1;
end

// High-speed adder (e.g., carry-save adder or carry-lookahead adder)
reg [N-1:0] sum;
always @(*) begin
    sum = abs_a + abs_b;
end

// Dedicated overflow detection block
reg overflow;
always @(*) begin
    overflow = (sum[N-1] == 1'b1);
end

// Overflow handling
reg [N-1:0] result;
always @(*) begin
    if (overflow) begin
        result = {1'b1, {N-1{1'b0}}};
    end else begin
        result = sum;
    end
end

// Assign result to output
always @(*) begin
    c = result;
end

endmodule