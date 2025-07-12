module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16   // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Internal signals with proper widths
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    reg signed [N-1:0] result;

    // Constants for saturation
    localparam signed [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam signed [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Main addition with overflow handling
    always @(*) begin
        result = a_signed + b_signed;
        
        // Detect positive overflow
        if ((a_signed > 0) && (b_signed > 0) && (result[N-1] == 1))
            result = MAX_POS;
        
        // Detect negative overflow
        else if ((a_signed < 0) && (b_signed < 0) && (result[N-1] == 0))
            result = MAX_NEG;
    end

    assign c = result;

endmodule