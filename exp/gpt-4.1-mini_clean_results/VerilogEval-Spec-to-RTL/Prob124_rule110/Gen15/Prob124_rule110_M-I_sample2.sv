module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // 8-bit LUT encoding Rule 110:
    // Index: {left, center, right} as bits [2:0]
    // Value: next state for center cell
    // As per the given truth table:
    // 111 -> 0
    // 110 -> 1
    // 101 -> 1
    // 100 -> 0
    // 011 -> 1
    // 010 -> 1
    // 001 -> 1
    // 000 -> 0
    localparam [7:0] RULE110_LUT = 8'b01101110;

    wire [511:0] next_state;
    genvar i;

    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_lut_logic
            wire left   = (i == 511) ? 1'b0 : q[i + 1];
            wire center = q[i];
            wire right  = (i == 0)   ? 1'b0 : q[i - 1];

            wire [2:0] neighborhood = {left, center, right};
            assign next_state[i] = RULE110_LUT[neighborhood];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule