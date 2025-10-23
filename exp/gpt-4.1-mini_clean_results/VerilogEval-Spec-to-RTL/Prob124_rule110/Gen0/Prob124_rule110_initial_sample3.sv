module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 truth table encoded in a 8-bit vector:
    // index = {left, center, right}, MSB index=7 = 111 pattern
    // For Rule 110, bits for patterns from 111 down to 000 are:
    // 111:0, 110:1, 101:1, 100:0, 011:1, 010:1, 001:1, 000:0
    // binary: 01101110 = 8'b01101110
    localparam [7:0] RULE110 = 8'b01101110;

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            // Get neighbors with boundary conditions
            wire left = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right = (i == 0) ? 1'b0 : q[i-1];

            wire [2:0] pattern = {left, center, right};

            // next state from RULE110 indexed by pattern
            assign next_q[i] = RULE110[pattern];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule