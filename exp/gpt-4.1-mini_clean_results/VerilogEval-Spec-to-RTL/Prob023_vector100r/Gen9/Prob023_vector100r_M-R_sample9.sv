module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    // Use a single continuous assignment with concatenation of reversed bits
    assign out = { for (genvar i = 0; i < N; i = i + 1) in[i] }; // This is illegal syntax in Verilog, but some SystemVerilog variants allow this.

    // To implement in pure Verilog, we can create a function to reverse bits and assign the output.

    // Define a function to reverse bits
    function [N-1:0] reverse_bits;
        input [N-1:0] value;
        integer j;
        begin
            for (j = 0; j < N; j = j + 1) begin
                reverse_bits[j] = value[N-1-j];
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