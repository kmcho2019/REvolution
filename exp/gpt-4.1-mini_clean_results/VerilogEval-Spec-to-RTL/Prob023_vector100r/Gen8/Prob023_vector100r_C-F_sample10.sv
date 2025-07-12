module BitRevN #(parameter N = 100) (
    input  wire [N-1:0] in,
    output wire [N-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : bit_reverse
            assign out[i] = in[N-1 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire          clk,
    input  wire          rst_n,
    input  wire [99:0]   in,
    output reg  [99:0]   out
);
    wire [99:0] reversed_bits;

    // Instantiate bit reversal module
    BitRevN #(100) bitrev_inst (
        .in(in),
        .out(reversed_bits)
    );

    // Pipeline register stage to improve timing and reduce glitches
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            out <= 100'b0;
        else
            out <= reversed_bits;
    end

endmodule