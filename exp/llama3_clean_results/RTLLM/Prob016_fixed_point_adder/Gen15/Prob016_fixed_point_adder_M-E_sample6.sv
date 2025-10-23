module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Internal wires and registers
reg [N-1:0] abs_a, abs_b;
reg [N-1:0] result;
reg [N-1:0] overflow;

// Stage 1: Handle sign bits and perform absolute value addition
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Same sign, add absolute values
        abs_a = a;
        abs_b = b;
    end else begin
        // Different signs, determine larger absolute value
        if (a[N-1] == 1'b0) begin
            abs_a = a;
            abs_b = ~b + 1'b1;
        end else begin
            abs_a = ~a + 1'b1;
            abs_b = b;
        end
    end
end

// Stage 2: Perform addition of absolute values
always @(*) begin
    result = abs_a + abs_b;
end

// Stage 3: Handle overflow and underflow conditions
always @(*) begin
    if (result >= (1 << N)) begin
        // Overflow, adjust output
        overflow = 1'b1;
        c = {1'b1, {N-1{1'b0}}};
    end else if (result < 0) begin
        // Underflow, adjust output
        overflow = 1'b0;
        c = {N{1'b0}};
    end else begin
        // No overflow or underflow, assign result
        overflow = 1'b0;
        c = result;
    end
end

// Stage 4: Adjust output based on precision (Q)
always @(*) begin
    if (Q < N) begin
        // Truncate fractional part to Q bits
        c = {c[N-1:Q], {Q{1'b0}}};
    end
end

endmodule