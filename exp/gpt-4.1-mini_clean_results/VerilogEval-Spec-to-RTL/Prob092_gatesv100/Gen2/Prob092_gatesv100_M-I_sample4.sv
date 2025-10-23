module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Mask for out_both: zero at bit 99, one elsewhere
    localparam [99:0] MASK_OUT_BOTH = {99{1'b1}, 1'b0};

    // Mask for out_any: zero at bit 0, one elsewhere
    localparam [99:0] MASK_OUT_ANY = {1'b0, {99{1'b1}}};

    // Function to rotate right by one bit
    function [99:0] rotate_right_1;
        input [99:0] vec;
        begin
            rotate_right_1 = {vec[0], vec[99:1]};
        end
    endfunction

    // out_both[i] = in[i] & in[i+1], last bit zero
    assign out_both = (in & (in << 1)) & MASK_OUT_BOTH;

    // out_any[i] = in[i] | in[i-1], first bit zero
    assign out_any = (in | (in >> 1)) & MASK_OUT_ANY;

    // out_different[i] = in[i] ^ in[(i+1)%100], wrap-around using rotate_right_1
    assign out_different = in ^ rotate_right_1(in);

endmodule