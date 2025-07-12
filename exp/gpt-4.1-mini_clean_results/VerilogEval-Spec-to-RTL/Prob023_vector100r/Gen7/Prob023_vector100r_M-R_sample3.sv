module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    assign out = {in[0], in[1 +: N-2], in[N-1]}; // placeholder to illustrate concatenation, replace below

    // Correct bit reversal using vector concatenation and bit-slicing
    // Create an expression that concatenates bits from MSB down to LSB
endmodule

module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    // Use a single assign with reduction concatenation of bits reversed via a function
    function [N-1:0] reverse_bits;
        input [N-1:0] data;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1) begin
                reverse_bits[i] = data[N - 1 - i];
            end
        end
    endfunction

    assign out = reverse_bits(in);
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );

endmodule