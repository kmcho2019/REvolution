module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_xor;
    wire [8:0] carry;
    wire [7:0] sum;

    genvar i;

    // Invert b if do_sub=1 to perform subtraction via two's complement
    assign b_xor = b ^ {8{do_sub}};

    // Carry-in is do_sub to add 1 in two's complement subtraction
    assign carry[0] = do_sub;

    // Generate block: ripple carry computation for each bit
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_generate
            assign sum[i]   = a[i] ^ b_xor[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b_xor[i]) | (a[i] & carry[i]) | (b_xor[i] & carry[i]);
        end
    endgenerate

    always @(*) begin
        // Blocking assignments for clean combinational logic
        out = sum;
        result_is_zero = ~|sum;
    end

endmodule