module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

    // Internal signals for sign handling and arithmetic stages
    reg signed [N-1:0] stage1_result;
    reg signed [N-1:0] stage2_result;

    // Sign handling stage
    always @(*) begin
        if (a[N-1] == b[N-1]) begin
            // Same sign subtraction
            stage1_result = a - b;
        end else begin
            // Different sign subtraction
            if (a[N-1] == 1'b0) begin
                // a is positive, b is negative
                stage1_result = a + (~b + 1);
            end else begin
                // a is negative, b is positive
                stage1_result = (~a + 1) + b;
            end
        end

        // Handle zero result
        if (stage1_result == 0) begin
            stage1_result = 0;
        end
    end

    // Arithmetic stage
    always @(*) begin
        // Perform arithmetic operation
        stage2_result = stage1_result;
    end

    // Output assignment
    always @(posedge stage2_result) begin
        c <= stage2_result;
    end

endmodule

module testbench;
    parameter Q = 8;  // Number of fractional bits
    parameter N = 16;  // Total number of bits

    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction

    fixed_point_subtractor #(.Q(Q),.N(N)) uut (
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