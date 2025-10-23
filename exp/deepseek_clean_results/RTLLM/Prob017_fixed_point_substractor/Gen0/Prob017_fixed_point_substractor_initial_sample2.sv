module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N-1:0] res;
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    always @(*) begin
        // Same sign case
        if (a_sign == b_sign) begin
            res[N-2:0] = a_mag - b_mag;
            res[N-1] = a_sign;  // Result has same sign as inputs
            
            // Handle zero case explicitly
            if (res[N-2:0] == 0) begin
                res[N-1] = 1'b0;
            end
        end
        // Different sign case
        else begin
            res[N-2:0] = a_mag + b_mag;
            
            // Determine result sign
            if (a_sign) begin  // a is negative, b is positive
                res[N-1] = (a_mag > b_mag) ? 1'b1 : 1'b0;
            end
            else begin  // a is positive, b is negative
                res[N-1] = (a_mag >= b_mag) ? 1'b0 : 1'b1;
            end
            
            // Handle zero case explicitly
            if (res[N-2:0] == 0) begin
                res[N-1] = 1'b0;
            end
        end
        
        c = res;
    end

endmodule