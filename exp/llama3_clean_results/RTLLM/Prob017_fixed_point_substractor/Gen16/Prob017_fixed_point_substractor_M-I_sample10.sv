module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,  // First N-bit fixed-point input operand
    input signed [N-1:0] b,  // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

// Separate integer and fractional parts of inputs
reg signed [N-Q-1:0] a_int;
reg signed [Q-1:0] a_frac;
reg signed [N-Q-1:0] b_int;
reg signed [Q-1:0] b_frac;

// Perform subtraction on integer parts
reg signed [N-Q:0] int_result;

// Perform subtraction on fractional parts
reg signed [Q:0] frac_result;

always @(*) begin
    // Separate integer and fractional parts
    a_int = a >>> Q;  // Shift right to extract integer part
    a_frac = a & ((1 << Q) - 1);  // Mask to extract fractional part
    b_int = b >>> Q;  // Shift right to extract integer part
    b_frac = b & ((1 << Q) - 1);  // Mask to extract fractional part
    
    // Perform subtraction
    int_result = a_int - b_int;
    frac_result = a_frac - b_frac;
    
    // Combine results, handling overflow and underflow
    if (int_result > (1 << (N-Q-1)) - 1) begin
        // Handle overflow
        c = {1'b1, {N-1{1'b1}}};
    end else if (int_result < -(1 << (N-Q-1))) begin
        // Handle underflow
        c = -{1'b1, {N-1{1'b0}}};
    end else begin
        // Combine integer and fractional parts
        c = (int_result << Q) + frac_result;
        
        // Handle sign based on input signs
        if ((a[N-1] == b[N-1]) && (a[N-1] == 1'b1)) begin
            // Both inputs are negative
            if (c < 0) begin
                // Result should be negative
            end else begin
                c = -c;  // Make result negative
            end
        end else if ((a[N-1] != b[N-1]) && (a[N-1] == 1'b1)) begin
            // a is negative, b is positive
            if (c > 0) begin
                // Result should be negative
                c = -c;
            end
        end else if ((a[N-1] != b[N-1]) && (b[N-1] == 1'b1)) begin
            // a is positive, b is negative
            if (c < 0) begin
                // Result should be positive
                c = -c;
            end
        end
        
        // Handle zero result
        if (c == 0) begin
            c = 0;  // Set sign bit to 0 for zero result
        end
    end
end

endmodule

// Testbench
module fixed_point_subtractor_tb;
    parameter Q = 8,  // Number of fractional bits
              N = 16;  // Total number of bits
    
    reg signed [N-1:0] a;  // First N-bit fixed-point input operand
    reg signed [N-1:0] b;  // Second N-bit fixed-point input operand
    wire signed [N-1:0] c;  // N-bit output representing the result of the fixed-point subtraction
    
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),  // Connect input a
        .b(b),  // Connect input b
        .c(c)   // Connect output c
    );
    
    initial begin
        a = 10;  // Example value for a
        b = 5;   // Example value for b
        
        #10;  // Wait for 10 time units
        $display("Result: %d", c);  // Display the result
        
        a = 10;
        b = 10;
        
        #10;  // Wait for 10 time units
        $display("Result when a == b: %d", c);  // Display the result when a equals b
        
        a = {1'b1, {N-1{1'b1}}};
        b = -{1'b1, {N-1{1'b0}}};
        
        #10;  // Wait for 10 time units
        $display("Result for overflow: %d", c);  // Display the result for overflow
        
        a = -{1'b1, {N-1{1'b0}}};
        b = {1'b1, {N-1{1'b1}}};
        
        #10;  // Wait for 10 time units
        $display("Result for underflow: %d", c);  // Display the result for underflow
        
        $finish;
    end
endmodule