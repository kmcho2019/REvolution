module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
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
        // Same sign subtraction
        if (a_sign == b_sign) begin
            res = a - b;
            // Handle zero case
            if (res[N-2:0] == 0) begin
                res[N-1] = 1'b0;
            end
        end
        // Different signs
        else begin
            if (a_sign) begin // a negative, b positive
                if (a_mag > b_mag) begin
                    res = {1'b1, a_mag - b_mag};
                end else begin
                    res = {1'b0, b_mag - a_mag};
                end
            end
            else begin // a positive, b negative
                if (a_mag > b_mag) begin
                    res = {1'b0, a_mag - b_mag};
                end else begin
                    res = {1'b1, b_mag - a_mag};
                end
            end
            // Handle zero case
            if (res[N-2:0] == 0) begin
                res[N-1] = 1'b0;
            end
        end
        c = res;
    end

endmodule