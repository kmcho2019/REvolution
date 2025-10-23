module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input clk,  // Clock signal
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Handle same and different sign subtractions
    assign c = (a[N-1] == b[N-1]) ? (a - b) : ((a[N-1] == 1'b0) ? (a + (~b + 1)) : ((~a + 1) + b));

    // Handle zero result on the next clock cycle
    always @(posedge clk) begin
        if (c == 0) begin
            c <= 0;
        end
    end

endmodule

module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg clk;  // Clock signal
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .clk(clk),
        .a(a),
        .b(b),
        .c(c)
    );

    initial begin
        clk = 0;
        a = 10;
        b = 5;
        #100;
        $display("Result: %d", c);
        forever #10 clk = ~clk;
    end

endmodule