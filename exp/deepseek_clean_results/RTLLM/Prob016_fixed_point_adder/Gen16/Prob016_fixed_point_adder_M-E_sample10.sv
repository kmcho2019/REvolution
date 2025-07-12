module fixed_point_adder #(
    parameter Q = 8,    // Number of fractional bits
    parameter N = 16,    // Total number of bits
    parameter SATURATE = 0  // 0: wrap-around, 1: saturate
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals
    wire [N:0] sum_ext;  // Extended sum for overflow detection
    wire overflow, underflow;
    reg [N-1:0] result;

    // Perform addition with extended sign bit
    assign sum_ext = {a[N-1], a} + {b[N-1], b};

    // Overflow detection
    assign overflow = (~a[N-1] & ~b[N-1] & sum_ext[N]);
    assign underflow = (a[N-1] & b[N-1] & ~sum_ext[N]);

    // Handle overflow/underflow based on saturation parameter
    always @(*) begin
        if (SATURATE) begin
            case ({overflow, underflow})
                2'b10: result = {1'b0, {(N-1){1'b1}}};  // Saturate to max positive
                2'b01: result = {1'b1, {(N-1){1'b0}}};  // Saturate to max negative
                default: result = sum_ext[N-1:0];       // Normal case
            endcase
        end
        else begin
            result = sum_ext[N-1:0];  // Wrap-around behavior
        end
    end

    // Output assignment
    assign c = result;

endmodule