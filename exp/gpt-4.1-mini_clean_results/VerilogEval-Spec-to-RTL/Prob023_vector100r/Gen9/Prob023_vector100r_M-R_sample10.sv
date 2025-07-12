module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    // Use a generate construct inside a localparam expression to build the reversed vector
    // using a concatenation of individual bits indexed in reverse order.
    // The expression uses a function to create the reversed vector at compile time.

    // Verilog does not support variable part selects dynamically in assignment,
    // so we use a function to build the reversed vector.

    function [N-1:0] reverse_bits;
        input [N-1:0] value;
        integer idx;
        begin
            for (idx = 0; idx < N; idx = idx + 1) begin
                reverse_bits[idx] = value[N - 1 - idx];
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