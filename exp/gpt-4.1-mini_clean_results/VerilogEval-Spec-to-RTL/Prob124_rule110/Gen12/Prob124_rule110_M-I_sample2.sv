module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend q with zero padding on both sides for boundary conditions
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    // Stage 1: compute next state combinationally and register it (pipeline stage)
    reg [511:0] next_q_reg;
    wire [511:0] next_q_comb;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110
            wire left   = ext_q[i + 2];
            wire center = ext_q[i + 1];
            wire right  = ext_q[i];
            // Rule 110: next state logic simplified as (~L & C) | (C ^ R)
            assign next_q_comb[i] = (~left & center) | (center ^ right);
        end
    endgenerate

    always @(posedge clk) begin
        // Pipeline stage: register next state bits
        next_q_reg <= next_q_comb;
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q_reg;
    end

endmodule