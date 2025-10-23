module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    // Compute next state bits as XOR of left and right neighbors
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : next_state_calc
            wire left  = (i == 0)   ? left_in      : q_out[i-1];
            wire right = (i == 63)  ? right_in     : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Clock enable: update only on load or if next_state differs from current state
    wire update_enable = load | (next_state != q_out);

    always @(posedge clk) begin
        if (update_enable) begin
            if (load)
                q_out <= data_in;
            else
                q_out <= next_state;
        end
        // else retain old q_out, saving switching power
    end
endmodule

module TopModule (
    input  wire        clk,
    input  wire        load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal 64-bit block outputs
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    // Generate boundary signals with a loop for clarity and scalability
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries
            if (i == 0) begin
                assign left_bounds[i]  = 1'b0;
            end else begin
                assign left_bounds[i]  = block_q[i-1][63];
            end

            if (i == 7) begin
                assign right_bounds[i] = 1'b0;
            end else begin
                assign right_bounds[i] = block_q[i+1][0];
            end
        end
    endgenerate

    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
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