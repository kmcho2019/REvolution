module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left neighbor boundary (registered)
    input  wire        right_in,  // right neighbor boundary (registered)
    output reg  [63:0] q_out
);
    // Register boundary inputs to break combinational chain and improve timing
    reg left_r, right_r;
    always @(posedge clk) begin
        left_r  <= left_in;
        right_r <= right_in;
    end

    wire [63:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : calc_next
            wire left_neighbor  = (i == 0)   ? left_r      : q_out[i-1];
            wire right_neighbor = (i == 63)  ? right_r     : q_out[i+1];
            assign next_state[i] = left_neighbor ^ right_neighbor;
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
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Split q and data into 8 blocks of 64 bits each
    wire [7:0] left_bounds;   // left boundary inputs to each block
    wire [7:0] right_bounds;  // right boundary inputs to each block
    wire [63:0] block_q [7:0];

    // External boundaries are zero
    assign left_bounds[0]  = 1'b0;
    assign right_bounds[7] = 1'b0;

    // Internal boundaries from neighboring blocks (registered inside each block)
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : internal_left_bounds
            assign left_bounds[i] = block_q[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : internal_right_bounds
            assign right_bounds[i] = block_q[i+1][0];
        end
    endgenerate

    // Instantiate 8 blocks of 64 cells
    generate
        for (i = 0; i < 8; i = i + 1) begin : blocks
            Rule90Block64 block (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(left_bounds[i]),
                .right_in(right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate

endmodule