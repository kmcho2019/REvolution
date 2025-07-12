module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);

    // Function to reverse bits of the input vector
    function [N-1:0] reverse_bits;
        input [N-1:0] value;
        integer idx;
        begin
            for (idx = 0; idx < N; idx = idx + 1) begin
                reverse_bits[idx] = value[N - 1 - idx];
            end
        end
    endfunction

    // Single continuous assignment of reversed vector
    assign out = reverse_bits(in);

endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(out)
    );
endmodule