module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Direct subtraction handles the fixed-point precision due to signed type
    always @(a or b) begin
        c = a - b;
        // Explicit handling for zero result to ensure correct sign bit
        if (c == 0) begin
            c = 0;  // Set sign bit to 0 for zero result
        end
    end

endmodule

module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  
        .b(b),  
        .c(c)   
    );

    initial begin
        a = 10;  
        b = 5;   
        #100;  
        $display("Result: %d", c);  
    end

endmodule