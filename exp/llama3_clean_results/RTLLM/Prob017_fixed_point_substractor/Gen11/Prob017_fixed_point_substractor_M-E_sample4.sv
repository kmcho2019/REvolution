module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Define internal signals to hold the integer and fractional parts of inputs
reg signed [N-Q-1:0] a_int, b_int;
reg signed [Q-1:0] a_frac, b_frac;

// Define an internal signal to store the result
reg signed [N-1:0] res;

// Separate integer and fractional parts based on Q
always @(*) begin
    a_int = a >> Q;
    a_frac = a & ((1 << Q) - 1);
    b_int = b >> Q;
    b_frac = b & ((1 << Q) - 1);
end

// Perform subtraction, handling signs and precision
always @(*) begin
    // Initialize result to 0
    res = 0;
    
    // Handle same sign subtraction
    if ((a[N-1] == b[N-1])) begin
        res = (a_int - b_int) << Q;
        res += (a_frac - b_frac);
    end
    // Handle different sign subtraction
    else begin
        // Absolute subtraction and addition based on signs
        if (a[N-1] == 0) begin // a is positive
            res = (a_int + b_int) << Q;
            res += (a_frac + b_frac);
        end
        else begin // a is negative
            res = (b_int - a_int) << Q;
            res += (b_frac - a_frac);
        end
    end
    
    // Normalize the result if necessary
    if (res >= (1 << N)) begin
        res = (1 << N) - 1; // Saturate at maximum value
    end
    else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1)); // Saturate at minimum value
    end
    
    // Handle zero result explicitly
    if (res == 0) begin
        c = 0; // Ensure sign bit is 0
    end
    else begin
        c = res;
    end
end

endmodule

// Example testbench
module testbench;
    parameter Q = 8;
    parameter N = 16;
    
    reg signed [N-1:0] a;
    reg signed [N-1:0] b;
    wire signed [N-1:0] c;
    
    fixed_point_subtractor #(.Q(Q), .N(N)) uut (
        .a(a),
        .b(b),
        .c(c)
    );
    
    initial begin
        a = 10; b = 5;
        #10; $display("Result: %d", c);
        a = -10; b = 5;
        #10; $display("Result: %d", c);
        a = 0; b = 0;
        #10; $display("Result: %d", c);
        $finish;
    end
    
endmodule