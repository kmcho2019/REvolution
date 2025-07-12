module fixed_point_adder #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Extended operands with one extra sign bit for overflow detection
    wire signed [N:0] a_ext = {{1{a[N-1]}}, a}; // sign-extend a
    wire signed [N:0] b_ext = {{1{b[N-1]}}, b}; // sign-extend b

    // Sum with extra bit
    reg signed [N:0] res;

    // Parameters for saturation limits
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}}; // max positive number
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}}; // most negative number (two's complement)

    // Signed versions of saturation limits with extension
    localparam signed [N:0] MAX_EXT = {1'b0, MAX_VAL};
    localparam signed [N:0] MIN_EXT = {1'b1, MIN_VAL};

    // Addition and saturation logic
    always @(*) begin
        res = a_ext + b_ext;

        // Overflow detection:
        // Overflow occurs if sign of res[N] != res[N-1]
        // That means sum doesn't fit in N bits
        if ( (res[N] != res[N-1]) ) begin
            // Saturate result
            if (res[N]) begin
                // Negative overflow
                res = MIN_EXT;
            end else begin
                // Positive overflow
                res = MAX_EXT;
            end
        end

        // Assign output - lower N bits (discard extra sign bit)
        c = res[N-1:0];
    end

endmodule