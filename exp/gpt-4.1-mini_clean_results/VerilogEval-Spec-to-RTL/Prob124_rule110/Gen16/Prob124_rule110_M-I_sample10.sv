module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Zero-padded extended vector for boundary conditions
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Rule 110 LUT: index = {left, center, right}
    // According to the table:
    // 111 -> 0
    // 110 -> 1
    // 101 -> 1
    // 100 -> 0
    // 011 -> 1
    // 010 -> 1
    // 001 -> 1
    // 000 -> 0
    // LUT bits from MSB index (7=111) to LSB index (0=000):
    // bit7  bit6  bit5  bit4  bit3  bit2  bit1  bit0
    //  0     1     1     0     1     1     1     0
    localparam [7:0] RULE110_LUT = 8'b01101110;

    wire [511:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : rule110_lut_logic
            wire [2:0] neighborhood = {ext_q[i + 2], ext_q[i + 1], ext_q[i]};
            // Index into LUT with neighborhood bits
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