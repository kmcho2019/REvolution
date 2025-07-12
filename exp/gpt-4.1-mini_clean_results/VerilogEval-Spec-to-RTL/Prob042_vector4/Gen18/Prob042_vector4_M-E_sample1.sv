module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // Function to replicate the sign bit N times
    function [23:0] replicate_sign;
        input sign_bit;
        integer i;
        begin
            replicate_sign = 24'b0;
            for (i = 0; i < 24; i = i + 1) begin
                replicate_sign[i] = sign_bit;
            end
        end
    endfunction

    wire sign_bit = in[7];
    wire [23:0] replicated_sign = replicate_sign(sign_bit);

    assign out = {replicated_sign, in};

endmodule