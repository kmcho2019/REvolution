module Rule90Block64 (
    input             clk,
    input             load,
    input      [63:0] data_in,
    input             left_in,        // Registered left neighbor boundary
    input             right_in,       // Registered right neighbor boundary
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : calc_next
            wire left  = (i == 0)   ? left_in       : q_out[i-1];
            wire right = (i == 63)  ? right_in      : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    // Load enable: update q_out if loading or if next_state differs to reduce toggling
    wire update_en = load | (q_out != next_state);

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else if (update_en)
            q_out <= next_state;
        // else retain previous q_out to avoid toggling
    end
endmodule

module TopModule (
    input              clk,
    input              load,
    input      [511:0] data,
    output     [511:0] q
);
    // Split the 512 cells into 8 blocks of 64 cells
    wire [63:0] block_q [7:0];

    // Boundary signals between blocks (raw, combinational)
    wire left_raw [7:0];
    wire right_raw[7:0];

    // Register boundary signals to reduce combinational path and glitches
    reg left_reg  [7:0];
    reg right_reg [7:0];

    integer idx;

    // Assign raw boundaries
    // Left boundary of block0 and right boundary of block7 are 0
    assign left_raw[0]  = 1'b0;
    assign right_raw[7] = 1'b0;

    // Internal boundaries from adjacent blocks
    generate
        genvar i;
        for (i = 1; i < 8; i = i + 1) begin : internal_left
            assign left_raw[i] = block_q[i-1][63];
        end
        for (i = 0; i < 7; i = i + 1) begin : internal_right
            assign right_raw[i] = block_q[i+1][0];
        end
    endgenerate

    // Register boundaries on clock to stabilize signals and reduce glitches
    always @(posedge clk) begin
        if (load) begin
            // On load, boundaries match loaded data edges
            left_reg[0] <= 1'b0;
            right_reg[7] <= 1'b0;
            for (idx = 1; idx < 8; idx = idx + 1) begin
                left_reg[idx] <= data[(idx-1)*64 + 63];
            end
            for (idx = 0; idx < 7; idx = idx + 1) begin
                right_reg[idx] <= data[(idx+1)*64];
            end
        end else begin
            // Normal operation: register boundary updates
            left_reg[0] <= 1'b0;
            right_reg[7] <= 1'b0;
            for (idx = 1; idx < 8; idx = idx + 1) begin
                left_reg[idx] <= block_q[idx-1][63];
            end
            for (idx = 0; idx < 7; idx = idx + 1) begin
                right_reg[idx] <= block_q[idx+1][0];
            end
        end
    end

    // Instantiate 8 blocks with registered boundaries
    generate
        genvar b;
        for (b = 0; b < 8; b = b + 1) begin : blocks
            Rule90Block64 block (
                .clk(clk),
                .load(load),
                .data_in(data[b*64 +: 64]),
                .left_in(left_reg[b]),
                .right_in(right_reg[b]),
                .q_out(block_q[b])
            );
            assign q[b*64 +: 64] = block_q[b];
        end
    endgenerate

endmodule