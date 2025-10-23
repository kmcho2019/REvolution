module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Rule 110 encoded as an 8-bit vector:
    // bit position = neighborhood {left, center, right}
    // 111=7->0, 110=6->1, 101=5->1, 100=4->0,
    // 011=3->1, 010=2->1, 001=1->1, 000=0->0
    localparam [7:0] RULE110 = 8'b01101110;

    wire [513:0] padded_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            wire left   = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right  = padded_q[i];
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