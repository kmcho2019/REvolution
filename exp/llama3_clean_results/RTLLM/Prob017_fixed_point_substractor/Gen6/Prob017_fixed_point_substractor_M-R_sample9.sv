module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Internal wires for intermediate results
wire [N-1:0] same_sign_result;
wire [N-1:0] diff_sign_result_a_positive;
wire [N-1:0] diff_sign_result_a_negative;

// Same sign subtraction
assign same_sign_result = (a[N-1] == b[N-1])? (a - b) : {N{1'b0}};

// Different sign subtraction: a is positive, b is negative
assign diff_sign_result_a_positive = (a[N-1] == 1'b0 && b[N-1] == 1'b1)? 
                                      (a >= ~b + 1)? (a + ~b + 1) : ~(~a + b + 1) : 
                                      {N{1'b0}};

// Different sign subtraction: a is negative, b is positive
assign diff_sign_result_a_negative = (a[N-1] == 1'b1 && b[N-1] == 1'b0)? 
                                      (~a + 1 >= b)? ~(~a + 1 - b) : (b - (~a + 1)) : 
                                      {N{1'b0}};

// Final result selection
always @(a or b) begin
    if (same_sign_result!= {N{1'b0}}) begin
        c = same_sign_result;
    end else if (diff_sign_result_a_positive!= {N{1'b0}}) begin
        c = diff_sign_result_a_positive;
    end else begin
        c = diff_sign_result_a_negative;
    end

    // Handle the zero result case
    if (c == 0) begin
        c[N-1] = 1'b0;  // Set the sign bit to 0
    end
end

endmodule