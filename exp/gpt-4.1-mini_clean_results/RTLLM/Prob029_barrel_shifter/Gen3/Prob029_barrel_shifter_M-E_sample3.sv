module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Calculate shift amount from ctrl bits (right rotate by shift_amount)
    wire [2:0] shift_amount = ctrl;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rotate_bits
            // Calculate source bit index with modulo 8
            // out[i] = in[(i + shift_amount) % 8]
            // Since Verilog does not do modulo on wires directly, do it via conditional subtraction
            wire [3:0] src_index = i + shift_amount;
            assign out[i] = in[(src_index >= 8) ? (src_index - 8) : src_index];
        end
    endgenerate
endmodule