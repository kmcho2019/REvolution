module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Stage 1 register: extended vector with zero padding
    reg [513:0] ext_q_reg;

    // Stage 2 register: partial next state computation (store intermediate values)
    reg [511:0] partial_next_q;

    // Stage 1 combinational: build extended vector and extract neighbors
    // We will separate neighbors into 3 separate 512-bit vectors: left, center, right
    wire [513:0] ext_q_next = {1'b0, q, 1'b0};

    // Wires for neighbors for stage 2
    wire [511:0] left   = ext_q_reg[513:2];    // bits [513:2], i.e. ext_q_reg[i+2]
    wire [511:0] center = ext_q_reg[512:1];    // bits [512:1], i.e. ext_q_reg[i+1]
    wire [511:0] right  = ext_q_reg[511:0];    // bits [511:0], i.e. ext_q_reg[i]

    // Stage 2 combinational: compute next state using partial_next_q = (~left & center) | (center ^ right)
    wire [511:0] next_q = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            // Load input data directly into q and initialize ext_q_reg accordingly
            q <= data;
            ext_q_reg <= {1'b0, data, 1'b0};
            partial_next_q <= 512'b0;
        end else begin
            // Pipeline the extended vector
            ext_q_reg <= ext_q_next;

            // Compute partial next state
            partial_next_q <= (~left & center) | (center ^ right);

            // On the next cycle, update q with the partial_next_q from previous cycle
            q <= partial_next_q;
        end
    end

endmodule