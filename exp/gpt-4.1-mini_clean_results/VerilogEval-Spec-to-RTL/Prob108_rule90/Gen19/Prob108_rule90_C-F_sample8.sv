module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,
    input  wire        right_in,
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

    // Registered boundary signals to reduce combinational path and glitches
    reg [7:0] left_bounds_reg;
    reg [7:0] right_bounds_reg;

    wire [7:0] left_bounds_next;
    wire [7:0] right_bounds_next;

    genvar i;
    // Combinational calculation of boundaries based on current q values
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries_comb
            assign left_bounds_next[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds_next[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Register boundary signals each clock to break combinational path
    always @(posedge clk) begin
        left_bounds_reg  <= left_bounds_next;
        right_bounds_reg <= right_bounds_next;
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