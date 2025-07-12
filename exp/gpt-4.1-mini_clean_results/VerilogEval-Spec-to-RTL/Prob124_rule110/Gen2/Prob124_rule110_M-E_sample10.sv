module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 lookup table: bit position = neighborhood pattern (binary), bit value = next state
    // Neighborhood bits ordered as {left, center, right}, 3-bit index from 0 to 7.
    // Bits: index: value
    // 0 (000) : 0
    // 1 (001) : 1
    // 2 (010) : 1
    // 3 (011) : 1
    // 4 (100) : 0
    // 5 (101) : 1
    // 6 (110) : 1
    // 7 (111) : 0
    localparam [7:0] RULE110_LUT = 8'b01101110;

    // Zero-padded extended vector to simplify neighbor extraction
    wire [513:0] q_ext;
    assign q_ext = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i=0; i<512; i=i+1) begin : cell_update
            wire [2:0] neighborhood = { q_ext[i+2], q_ext[i+1], q_ext[i] }; // left=center+1, center=i, right=center-1
            assign next_q[i] = RULE110_LUT[neighborhood];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule