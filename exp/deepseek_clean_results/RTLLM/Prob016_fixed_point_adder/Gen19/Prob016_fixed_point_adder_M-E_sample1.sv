module fixed_point_adder #(
    parameter Q = 8,        // Number of fractional bits
    parameter N = 16,       // Total number of bits
    parameter ROUND = 0,    // Enable rounding (0: truncate, 1: round)
    parameter PIPELINE = 0  // Enable pipelining
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output reg overflow    // Overflow detection flag
);

    // Parameter validation
    initial begin
        if (Q >= N) begin
            $error("Q must be less than N");
            $finish;
        end
    end

    // Internal signals
    wire [N:0] sum_raw;          // Extended sum with carry out
    wire [N-1:0] sum_saturated;  // Saturated result
    wire round_bit;              // Rounding bit (LSB of truncated bits)
    wire [N-1:0] sum_rounded;    // Rounded result

    // Carry-lookahead style addition
    assign sum_raw = {a[N-1], a} + {b[N-1], b};
    assign round_bit = (ROUND) ? sum_raw[Q-1] : 1'b0;

    // Saturation logic
    assign sum_saturated = 
        (~sum_raw[N] & sum_raw[N-1]) ? {1'b0, {(N-1){1'b1}}} : // Positive overflow
        (sum_raw[N] & ~sum_raw[N-1]) ? {1'b1, {(N-1){1'b0}}} :  // Negative overflow
        sum_raw[N-1:0];                                         // Normal case

    // Rounding logic
    assign sum_rounded = sum_saturated + round_bit;

    // Overflow detection
    always @(*) begin
        overflow = (sum_raw[N] != sum_raw[N-1]);
        if (PIPELINE) begin
            c = sum_rounded;
        end
    end

    // Optional pipeline register
    generate
        if (PIPELINE) begin
            always @(posedge clk) begin
                c <= sum_rounded;
                overflow <= (sum_raw[N] != sum_raw[N-1]);
            end
        end else begin
            always @(*) begin
                c = sum_rounded;
            end
        end
    endgenerate

endmodule