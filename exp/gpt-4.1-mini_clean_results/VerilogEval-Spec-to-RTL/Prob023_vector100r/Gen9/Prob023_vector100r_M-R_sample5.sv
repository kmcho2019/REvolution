module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Function to reverse bits of input vector
    function [N-1:0] reverse_bits;
        input [N-1:0] data;
        integer i;
        begin
            for (i = 0; i < N; i = i + 1) begin
                reverse_bits[i] = data[N-1 - i];
            end
        end
    endfunction

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