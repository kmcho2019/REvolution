module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Full subtractor: computes difference bit and borrow out
    // Inputs: a, b, borrow_in
    // Outputs: diff = a - b - borrow_in, borrow_out generated accordingly
    // borrow_out = 1 if borrow needed
    function automatic [1:0] full_subtract;
        input a, b, borrow_in;
        reg diff_bit;
        reg borrow_out_bit;
        begin
            diff_bit = a ^ b ^ borrow_in;
            borrow_out_bit = (~a & b) | ((~a | b) & borrow_in);
            full_subtract = {borrow_out_bit, diff_bit};
        end
    endfunction

    wire [3:0] diff;         // difference bits
    wire [4:0] borrow;       // borrow chain: borrow[0] initial 0
    assign borrow[0] = 1'b0; // initial borrow in is 0

    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin : SUBTRACT_BITS
            wire borrow_out_i;
            wire diff_i;
            // Perform full subtract on bit i
            // full_subtract returns {borrow_out, diff}
            wire [1:0] sub_res = full_subtract(A[i], B[i], borrow[i]);
            assign borrow[i+1] = sub_res[1] ? 1'b1 : 1'b0; // borrow out bit
            assign diff[i] = sub_res[0];
        end
    endgenerate

    // borrow_out = borrow[4] (final borrow)
    // equality check: if all diff bits are zero, then A == B
    wire zero_diff = ~|diff; // NOR of diff bits

    assign A_less    = borrow[4];
    assign A_equal   = ~borrow[4] & zero_diff;
    assign A_greater = ~borrow[4] & ~zero_diff;

endmodule