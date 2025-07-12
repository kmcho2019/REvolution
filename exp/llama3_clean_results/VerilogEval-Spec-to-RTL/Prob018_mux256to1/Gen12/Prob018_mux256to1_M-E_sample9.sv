module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output out // 1-bit output
);

    wire [15:0] chunk_out; // outputs of 16-to-1 multiplexers

    // 16 16-to-1 multiplexers
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            multiplexer_16to1 u_multiplexer_16to1(
               .in(in[(i * 16 + 15) : (i * 16)]), // 16-bit chunk of input vector
               .sel(sel[3:0]), // lower 4 bits of select signal
               .out(chunk_out[i]) // output of 16-to-1 multiplexer
            );
        end
    endgenerate

    // final 16-to-1 multiplexer
    multiplexer_16to1 u_final_multiplexer(
       .in(chunk_out), // outputs of 16-to-1 multiplexers
       .sel(sel[7:4]), // upper 4 bits of select signal
       .out(out) // final output
    );

endmodule

// 16-to-1 multiplexer module
module multiplexer_16to1(
    input [15:0] in, // 16-bit input vector
    input [3:0] sel, // 4-bit select signal
    output out // 1-bit output
);

    assign out = in[sel];

endmodule