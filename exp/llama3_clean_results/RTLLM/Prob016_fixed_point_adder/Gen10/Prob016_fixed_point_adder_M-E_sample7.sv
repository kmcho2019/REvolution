module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Internal signals
reg [N-1:0] int_a, int_b;
reg [Q-1:0] frac_a, frac_b;
reg [N-1:0] int_res;
reg [Q-1:0] frac_res;

// Operand Splitter
always @(*) begin
    int_a = a[N-1-Q+1:N-Q];
    frac_a = a[N-Q-1:0];
    int_b = b[N-1-Q+1:N-Q];
    frac_b = b[N-Q-1:0];
end

// Integer Part Adder/Subtractor
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        int_res = int_a + int_b;
    end else begin
        if (int_a > int_b) begin
            int_res = int_a - int_b;
        end else begin
            int_res = int_b - int_a;
        end
    end
end

// Fractional Part Adder/Subtractor
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        frac_res = frac_a + frac_b;
    end else begin
        if (frac_a > frac_b) begin
            frac_res = frac_a - frac_b;
        end else begin
            frac_res = frac_b - frac_a;
        end
    end
end

// Precision Handling Module
always @(*) begin
    if (int_res[N-1-Q] == 1'b1) begin
        // Overflow, adjust result
        c = {N{1'b1}};
    end else if (int_res == 0 && frac_res == 0) begin
        // Underflow, set to zero
        c = {N{1'b0}};
    end else begin
        // Combine integer and fractional parts
        c = {int_res, frac_res};
    end
end

endmodule