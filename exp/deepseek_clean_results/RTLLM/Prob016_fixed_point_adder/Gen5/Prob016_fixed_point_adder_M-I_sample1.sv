module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? ~a[N-2:0] + 1'b1 : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? ~b[N-2:0] + 1'b1 : b[N-2:0];
    
    wire signs_equal = (a_sign == b_sign);
    wire a_larger = (a_mag > b_mag);
    
    reg [N-1:0] res;
    reg overflow;
    
    always @(*) begin
        overflow = 1'b0;
        
        if (signs_equal) begin
            // Same sign addition
            res = {a_sign, a_mag} + {b_sign, b_mag};
            
            // Overflow detection
            if (a_sign == res[N-1]) begin
                // Normal case
                c = res;
            end else begin
                // Overflow occurred - saturate
                c = a_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
                overflow = 1'b1;
            end
        end else begin
            // Different signs - subtraction
            if (a_larger) begin
                res = {1'b0, a_mag - b_mag};
                c = a_sign ? {1'b1, res[N-2:0]} : res;
            end else begin
                res = {1'b0, b_mag - a_mag};
                c = b_sign ? {1'b1, res[N-2:0]} : res;
            end
            
            // Special case for zero result
            if (res[N-2:0] == {(N-1){1'b0}}) begin
                c = {1'b0, res[N-2:0]};
            end
        end
    end

endmodule