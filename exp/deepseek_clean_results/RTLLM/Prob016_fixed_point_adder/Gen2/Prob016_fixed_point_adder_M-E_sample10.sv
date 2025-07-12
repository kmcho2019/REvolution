module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Extended precision for accurate calculations
    localparam EXT_WIDTH = N + 1;
    wire [EXT_WIDTH-1:0] a_ext = {{1{a[N-1]}}, a};
    wire [EXT_WIDTH-1:0] b_ext = {{1{b[N-1]}}, b};
    wire [EXT_WIDTH-1:0] sum_ext = a_ext + b_ext;

    // Overflow occurs when sign bits don't match and result sign differs
    wire overflow = (a[N-1] == b[N-1]) && (sum_ext[EXT_WIDTH-1] != a[N-1]);

    always @(*) begin
        if (overflow) begin
            // Saturate to maximum positive or negative value
            c = a[N-1] ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}}};
        end else begin
            // Normal case - truncate to N bits
            c = sum_ext[N-1:0];
            
            // Special case: result is exactly zero
            if (sum_ext[EXT_WIDTH-2:0] == 0) begin
                c = 0;
            end
        end
    end

endmodule