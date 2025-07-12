module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0; // We will handle reset value externally
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    wire [7:0] q_int;
    genvar i;

    // We implement synchronous reset to set q to 0x34.
    // Since DFF module only resets to zero,
    // use mux before the DFF input to select reset value bits or d bits.
    // On reset, drive the flip-flop input to reset value bits (0x34)
    // so that when negedge clk happens, q will get reset bits.

    wire [7:0] dff_d;

    assign dff_d = reset ? 8'h34 : d;

    generate
        for (i = 0; i < 8; i = i + 1) begin : dffs
            DFF dff_i (
                .clk(clk),
                .reset(1'b0),  // DFF reset tied to 0, actual reset implemented by input mux
                .d(dff_d[i]),
                .q(q_int[i])
            );
        end
    endgenerate

    assign q = q_int;

endmodule