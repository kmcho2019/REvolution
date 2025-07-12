module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // registered left boundary
    input  wire        right_in,   // registered right boundary
    output reg  [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_logic
            wire left  = (i == 0)   ? left_in  : q_out[i-1];
            wire right = (i == 63)  ? right_in : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    wire [63:0] block_q [7:0];

    // Registered boundaries to reduce glitches and improve timing/power
    reg  [7:0] left_bounds_reg;
    reg  [7:0] right_bounds_reg;

    // Combinational boundaries (from current q outputs)
    wire [7:0] left_bounds_comb;
    wire [7:0] right_bounds_comb;

    genvar i;
    // Generate combinational boundary signals
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries_comb
            assign left_bounds_comb[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds_comb[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Register boundaries each clock cycle to reduce glitches and pipelining
    always @(posedge clk) begin
        left_bounds_reg  <= left_bounds_comb;
        right_bounds_reg <= right_bounds_comb;
    end

    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds_reg[i]),
                .right_in(right_bounds_reg[i]),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule