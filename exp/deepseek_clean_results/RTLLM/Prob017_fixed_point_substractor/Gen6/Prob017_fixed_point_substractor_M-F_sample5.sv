module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32    // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-2:0] a_mag = a[N-2:0];
wire [N-2:0] b_mag = b[N-2:0];
wire [N-1:0] abs_a = {1'b0, a_mag};
wire [N-1:0] abs_b = {1'b0, b_mag};
wire [N-1:0] res;

// Main subtraction logic
assign res = (a_sign == b_sign) ? 
             {a_sign, (a_mag - b_mag)} :  // Same signs case
             (a_sign ?                    // Different signs cases
              ((abs_b > abs_a) ? {1'b0, (abs_b - abs_a)} : {1'b1, (abs_a - abs_b)}) :
              ((abs_a > abs_b) ? {1'b0, (abs_a - abs_b)} : {1'b1, (abs_b - abs_a)});

// Zero handling and output assignment
always @(*) begin
    c = res;
    if (res[N-2:0] == {(N-1){1'b0}}) begin
        c[N-1] = 1'b0;  // Force positive zero
    end
end

endmodule