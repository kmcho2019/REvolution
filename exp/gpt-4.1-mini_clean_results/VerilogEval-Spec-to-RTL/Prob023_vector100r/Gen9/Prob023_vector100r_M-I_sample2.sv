module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N - 1 - i];
        end
    endgenerate
endmodule

module TopModulePipelined (
    input  wire         clk,
    input  wire [99:0]  in,
    output reg  [99:0]  out
);
    wire [99:0] reversed_bits;

    // Combinational bit reversal
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(reversed_bits)
    );

    // Register stage to reduce glitches and improve timing/power
    always @(posedge clk) begin
        out <= reversed_bits;
    end
endmodule