module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,   // left boundary (0 if none)
    input  wire        right_in,  // right boundary (0 if none)
    output reg  [63:0] q_out
);
    // Compute left neighbors vector with left_in at bit 0, shifted q_out[63:1]
    wire [63:0] left_neighbors = {q_out[62:0], left_in};

    // Compute right neighbors vector with right_in at bit 63, shifted q_out[62:0]
    wire [63:0] right_neighbors = {right_in, q_out[63:1]};

    // Next state is XOR of left and right neighbors for all bits at once
    wire [63:0] next_state = left_neighbors ^ right_neighbors;

    // Clock enable: update only if loading or next_state differs from q_out
    wire clk_en = load || (next_state != q_out);

    always @(posedge clk) begin
        if (clk_en) begin
            if (load)
                q_out <= data_in;
            else
                q_out <= next_state;
        end
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output wire [511:0] q
);
    // Internal 64-bit block outputs
    wire [63:0] block_q [7:0];

    genvar i;

    // Generate boundary signals between blocks with generate loop for clarity
    wire [7:0] left_bounds;
    wire [7:0] right_bounds;

    generate
        for (i = 0; i < 8; i = i + 1) begin : boundary_assign
            if (i == 0) begin
                assign left_bounds[i]  = 1'b0;
            end else begin
                assign left_bounds[i] = block_q[i-1][63];
            end

            if (i == 7) begin
                assign right_bounds[i] = 1'b0;
            end else begin
                assign right_bounds[i] = block_q[i+1][0];
            end
        end
    endgenerate

    // Instantiate Rule90Block64 modules
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