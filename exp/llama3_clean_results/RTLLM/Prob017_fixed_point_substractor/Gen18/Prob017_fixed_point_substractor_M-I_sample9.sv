module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    localparam INTEGER_PART_LENGTH = N - Q;

    always @(*) begin
        // Perform subtraction directly, handling signs and zero
        c = a - b;
        
        // Explicitly set sign bit to 0 when result is zero
        if (c == 0) begin
            c = 0;
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