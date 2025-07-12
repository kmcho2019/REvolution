module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input clk,  // Clock signal
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Internal signal for result
    reg signed [N-1:0] res;

    // Combinational logic for subtraction
    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign subtraction
            res = a - b;
        end else begin
            // Different sign subtraction
            if (a[N-1] == 1'b0) begin
                // a is positive, b is negative
                res = a + (~b + 1);
            end else begin
                // a is negative, b is positive
                res = (~a + 1) + b;
            end
        end

        // Handle zero result
        if (res == 0) begin
            res = 0;
        end
    end

    // Synchronous output assignment
    always @(posedge clk) begin
        c <= res;
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
        forever #10 clk = ~clk;
    end

    initial begin
        a = 10;  
        b = 5;   
        #100;  
        $display("Result: %d", c);  
    end

endmodule