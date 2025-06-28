module TopModule (
    input clk,
    input in,
    output logic out
);

    logic xor_input;
    logic flipflop_output;

    assign xor_input = in ^ flipflop_output;

    always_ff @(posedge clk)
        flipflop_output <= xor_input;

    assign out = flipflop_output;

endmodule