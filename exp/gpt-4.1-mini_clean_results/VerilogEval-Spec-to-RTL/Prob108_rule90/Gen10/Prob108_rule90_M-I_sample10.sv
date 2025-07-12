module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    input left_in,        // left boundary (0 if no neighbor)
    input right_in,       // right boundary (0 if no neighbor)
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : rule90_bit_logic
            wire left  = (i == 0)   ? left_in     : q_out[i-1];
            wire right = (i == 63)  ? right_in    : q_out[i+1];
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
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    wire [63:0] block_q [7:0];
    wire [63:0] block_q_reg [7:0]; // Registered outputs for boundary signals

    // Register boundary bits between blocks to reduce fanout and improve timing
    reg left_bounds [7:0];
    reg right_bounds [7:0];

    // Left and right boundaries of system are zero
    // Initialize left_bounds[0] and right_bounds[7] to 0 synchronously
    always @(posedge clk) begin
        left_bounds[0]  <= 1'b0;
        right_bounds[7] <= 1'b0;
        // Register internal boundaries from neighbors
        // left_bounds[i] = block_q[i-1][63]
        // right_bounds[i] = block_q[i+1][0]
        integer idx;
        for (idx = 1; idx < 8; idx = idx +1) begin
            left_bounds[idx] <= block_q[idx-1][63];
        end
        for (idx = 0; idx < 7; idx = idx + 1) begin
            right_bounds[idx] <= block_q[idx+1][0];
        end
    end

    genvar i;
    generate
        for (i=0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 block_inst (
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