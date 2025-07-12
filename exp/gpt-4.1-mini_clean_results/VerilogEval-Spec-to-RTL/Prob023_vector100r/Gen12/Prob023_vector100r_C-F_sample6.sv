module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    // Generate a reversed bit vector as a concatenation of input bits indexed from high to low
    wire [N-1:0] reversed;
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_reverse_concat
            // Assign each bit of reversed vector from reversed input bit
            assign reversed[i] = in[N - 1 - i];
        end
    endgenerate

    // Assign the reversed wire vector directly to output in one statement
    assign out = reversed;

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