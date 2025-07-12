module TopModule(
    input  [7:0] in,
    output [31:0] out
);

    // Function to sign extend an 8-bit input to 32 bits
    function [31:0] sign_extend_8_to_32;
        input [7:0] value;
        begin
            sign_extend_8_to_32 = { {24{value[7]}}, value };
        end
    endfunction

    // Continuous assignment using the function
    assign out = sign_extend_8_to_32(in);

endmodule