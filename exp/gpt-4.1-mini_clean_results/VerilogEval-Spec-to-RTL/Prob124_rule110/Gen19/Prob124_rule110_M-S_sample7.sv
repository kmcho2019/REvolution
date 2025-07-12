module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Extended state with zero-padded boundaries: q[-1]=0, q[512]=0
    // Create a 514-bit vector: {left_zero, q, right_zero}
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            // For bit i, neighbors are:
            // left: ext_q[i+2]
            // center: ext_q[i+1]
            // right: ext_q[i]
            wire left = ext_q[i+2];
            wire center = ext_q[i+1];
            wire right = ext_q[i];
            // Rule 110: next = (~left & center) | (center ^ right);
            assign next_q[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule