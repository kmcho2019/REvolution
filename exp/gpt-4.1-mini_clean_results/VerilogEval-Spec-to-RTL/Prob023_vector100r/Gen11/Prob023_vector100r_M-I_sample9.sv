module BitRevN #(parameter N = 100) (
    input  [N-1:0] in,
    output [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input             clk,
    input             rst_n,  // active low synchronous reset
    input      [99:0] in,
    output reg [99:0] out
);
    wire [99:0] reversed_bits;

    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(reversed_bits)
    );

    // Registered output to improve timing and reduce power switching
    always @(posedge clk) begin
        if (!rst_n)
            out <= 100'b0;
        else
            out <= reversed_bits;
    end
endmodule