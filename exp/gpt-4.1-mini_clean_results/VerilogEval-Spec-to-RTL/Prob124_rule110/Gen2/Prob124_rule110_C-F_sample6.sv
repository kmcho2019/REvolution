module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 encoded as an 8-bit vector: 
    // bit position = neighborhood pattern {left, center, right}
    // pattern=7 (111) -> bit0 of RULE110[7] = 0
    // pattern=6 (110) -> 1
    // pattern=5 (101) -> 1
    // pattern=4 (100) -> 0
    // pattern=3 (011) -> 1
    // pattern=2 (010) -> 1
    // pattern=1 (001) -> 1
    // pattern=0 (000) -> 0
    localparam [7:0] RULE110 = 8'b01101110;

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            wire left   = (i == 511) ? 1'b0 : q[i+1];
            wire center = q[i];
            wire right  = (i == 0) ? 1'b0 : q[i-1];

            wire [2:0] neighborhood = {left, center, right};

            assign next_q[i] = RULE110[neighborhood];
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule