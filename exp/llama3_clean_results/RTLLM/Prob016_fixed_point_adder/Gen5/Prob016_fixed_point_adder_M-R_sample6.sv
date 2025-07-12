module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

wire [N-Q-1:0] int_a, int_b; // Integer parts of a and b
wire [Q-1:0] frac_a, frac_b; // Fractional parts of a and b
reg [N:0] temp_res; // Temporary result
reg sign_a, sign_b; // Signs of a and b

// Separate integer and fractional parts
assign int_a = a[N-1:Q];
assign int_b = b[N-1:Q];
assign frac_a = a[Q-1:0];
assign frac_b = b[Q-1:0];

// Determine signs of a and b
assign sign_a = a[N-1];
assign sign_b = b[N-1];

always @(*) begin
    // Perform addition or subtraction based on sign
    if (sign_a == sign_b) begin
        // Same signs, add absolute values
        temp_res = ({int_a, frac_a} + {int_b, frac_b});
    end else begin
        // Different signs, subtract
        if ({int_a, frac_a} >= {int_b, frac_b}) begin
            temp_res = {int_a, frac_a} - {int_b, frac_b};
        end else begin
            temp_res = {int_b, frac_b} - {int_a, frac_a};
        end
    end

    // Check for overflow
    if (temp_res >= (1 << N)) begin
        c = (1 << N) - 1;
    end else if (temp_res < 0) begin
        c = 0;
    end else begin
        // Extract integer and fractional parts from the result
        c = temp_res[N-1:0];
    end
end

endmodule