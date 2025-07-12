module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input clk,  // Clock signal for pipelining and clock gating
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Explicit handling of edge cases
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different sign
        if (a[N-1] == 0) begin  // a is positive, b is negative
            res = a + (~b + 1);  // Two's complement addition
        end else begin  // a is negative, b is positive
            res = (~a + 1) + b;  // Two's complement addition
        end
    end
    if (res == 0) begin  // Handling zero result
        c <= {1'b0, {N-1{1'b0}}};  // Explicitly set sign bit to 0
    end else begin
        c <= res;
    end
end

// Clock gating for power optimization
always @(posedge clk) begin
    if (a != 0 || b != 0) begin  // Only update output when inputs are non-zero
        c <= res;
    end
end

endmodule

// Example testbench code to demonstrate correct instantiation and usage.
module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg clk;  // Clock signal
    reg [N-1:0] a;  // First N-bit fixed-point input operand
    reg [N-1:0] b;  // Second N-bit fixed-point input operand
    wire [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    // Explicitly check parameter consistency
    initial begin
        if (Q > N) begin
            $display("Error: Q cannot be greater than N");
            $finish;
        end
    end

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .clk(clk),  // Clock signal
        .a(a),  // First N-bit fixed-point input operand
        .b(b),  // Second N-bit fixed-point input operand
        .c(c)  // N-bit output representing the result of the fixed-point subtraction
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        #100;  // Delay to observe the output
        $display("Result: %d", c);  // Display the result
    end

endmodule