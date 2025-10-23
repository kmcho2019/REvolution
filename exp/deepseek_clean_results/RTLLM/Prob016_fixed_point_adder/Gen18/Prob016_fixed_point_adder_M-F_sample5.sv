module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign - simple addition
            res = {a_sign, a_mag + b_mag};
        end
        else begin
            // Different signs - subtraction
            if (a_mag > b_mag) begin
                res = {a_sign, a_mag - b_mag};
            end
            else if (b_mag > a_mag) begin
                res = {b_sign, b_mag - a_mag};
            end
            else begin
                // Equal magnitude - result is zero
                res = 0;
            end
        end
    end

    assign c = res;

endmodule