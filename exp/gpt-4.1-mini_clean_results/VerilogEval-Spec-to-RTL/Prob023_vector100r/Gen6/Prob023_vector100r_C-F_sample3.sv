module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    // Function to reverse bits of input vector
    function [N-1:0] reverse_bits;
        input [N-1:0] val;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1) begin
                reverse_bits[i] = val[N-1 - i];
            end
        end
    endfunction

    // Assign output as the reversed input using the function
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