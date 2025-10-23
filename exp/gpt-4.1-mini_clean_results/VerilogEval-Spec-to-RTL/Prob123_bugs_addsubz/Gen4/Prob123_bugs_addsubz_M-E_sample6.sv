module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    wire [7:0] b_invert;
    wire [7:0] sum;
    wire [7:0] carry;

    // Invert B bits conditionally based on do_sub
    assign b_invert = b ^ {8{do_sub}};

    // Carry chain generation: carry[0] = do_sub (borrow in)
    assign carry[0] = do_sub;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : ADD_SUB_BITS
            // Full adder logic for each bit:
            // sum = a ^ b_invert ^ carry_in
            // carry_out = (a & b_invert) | (a & carry_in) | (b_invert & carry_in)
            assign sum[i] = a[i] ^ b_invert[i] ^ carry[i];
            if (i < 7) begin
                assign carry[i+1] = (a[i] & b_invert[i]) | (a[i] & carry[i]) | (b_invert[i] & carry[i]);
            end
        end
    endgenerate

    always @(*) begin
        out = sum;
        result_is_zero = ~|sum; // reduction NOR to set zero flag
    end

endmodule