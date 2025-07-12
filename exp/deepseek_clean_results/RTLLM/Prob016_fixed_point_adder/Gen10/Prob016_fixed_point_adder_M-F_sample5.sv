module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Parameter validation
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Pre-calculate saturation constants
    localparam [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Internal signals
    wire [N:0] sum_ext;  // Extended sum for overflow detection
    
    // Perform addition with extended bit for overflow detection
    assign sum_ext = {a[N-1], a} + {b[N-1], b};
    
    always @(*) begin
        casex ({sum_ext[N], sum_ext[N-1]})
            2'b01:  c = MAX_POS;  // Positive overflow
            2'b10:  c = MAX_NEG;  // Negative overflow
            default: c = sum_ext[N-1:0];  // Normal case
        endcase
    end

endmodule