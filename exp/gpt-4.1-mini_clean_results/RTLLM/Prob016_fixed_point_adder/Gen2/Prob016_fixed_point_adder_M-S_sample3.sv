module fixed_point_adder #(parameter N = 16, parameter Q = 8) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    wire [N-1:0] add_mag = {1'b0, a_mag} + {1'b0, b_mag};
    wire [N-1:0] sub_a_b  = {1'b0, a_mag} - {1'b0, b_mag};
    wire [N-1:0] sub_b_a  = {1'b0, b_mag} - {1'b0, a_mag};

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes, keep sign
            res[N-2:0] = add_mag[N-2:0];
            res[N-1]   = a_sign;
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (a_mag == b_mag) begin
                res = {N{1'b0}}; // zero result
            end else if (a_mag > b_mag) begin
                res[N-2:0] = sub_a_b[N-2:0];
                res[N-1]   = a_sign; // sign of larger magnitude
            end else begin
                res[N-2:0] = sub_b_a[N-2:0];
                res[N-1]   = b_sign;
            end
        end
        c = res;
    end

endmodule