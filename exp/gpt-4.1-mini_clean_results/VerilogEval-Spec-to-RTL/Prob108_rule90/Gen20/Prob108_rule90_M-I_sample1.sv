module Rule90Block64 (
    input  wire        clk,
    input  wire        load,
    input  wire [63:0] data_in,
    input  wire        left_in,    // registered left boundary (from boundary reg)
    input  wire        right_in,   // registered right boundary (from boundary reg)
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
    // Unregistered raw boundaries (combinational from current q)
    wire [7:0] raw_left_bounds;
    wire [7:0] raw_right_bounds;

    // Registered boundary signals to feed blocks
    reg [7:0] reg_left_bounds;
    reg [7:0] reg_right_bounds;

    genvar i;
    // Assign raw boundaries from q outputs of adjacent blocks
    generate
        for (i = 0; i < 8; i = i + 1) begin : raw_boundaries
            assign raw_left_bounds[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign raw_right_bounds[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Boundary registers capture raw boundaries every clock
    always @(posedge clk) begin
        if (load) begin
            // During load, boundaries set from loaded data neighbors
            // Extract left and right boundary bits from input data
            reg_left_bounds[0] <= 1'b0;
            reg_right_bounds[7] <= 1'b0;
            for (int idx = 1; idx < 8; idx = idx + 1) begin
                reg_left_bounds[idx] <= data[(idx-1)*64 + 63];
            end
            for (int idx = 0; idx < 7; idx = idx + 1) begin
                reg_right_bounds[idx] <= data[(idx+1)*64 + 0];
            end
        end else begin
            // Normal update: register boundary signals from previous cycle's q
            reg_left_bounds <= raw_left_bounds;
            reg_right_bounds <= raw_right_bounds;
        end
    end

    // Instantiate 8 blocks
    generate
        for (i = 0; i < 8; i = i + 1) begin : rule90_blocks
            Rule90Block64 block_inst (
                .clk(clk),
                .load(load),
                .data_in(data[i*64 +: 64]),
                .left_in(reg_left_bounds[i]),
                .right_in(reg_right_bounds[i]),
                .q_out(block_q[i])
            );
            assign q[i*64 +: 64] = block_q[i];
        end
    endgenerate
endmodule