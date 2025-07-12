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

    // Registered boundary signals to break combinational chain and improve timing
    reg [7:0] left_bounds_reg;
    reg [7:0] right_bounds_reg;

    // Wires to connect block outputs to boundary inputs before registering
    wire [7:0] left_bounds_next;
    wire [7:0] right_bounds_next;

    genvar i;
    generate
        // Compute next cycle boundary bits from block outputs
        for (i = 0; i < 8; i = i + 1) begin : boundaries_next_compute
            assign left_bounds_next[i]  = (i == 0) ? 1'b0 : block_q[i-1][63];
            assign right_bounds_next[i] = (i == 7) ? 1'b0 : block_q[i+1][0];
        end
    endgenerate

    // Register boundary bits on clk to break combinational dependencies
    always @(posedge clk) begin
        if (load) begin
            // On load, initialize boundary registers based on loaded data
            // For block 0 left boundary is zero, others take MSB of previous block's data
            left_bounds_reg[0] <= 1'b0;
            right_bounds_reg[7] <= 1'b0;
            // For left boundaries (except 0)
            left_bounds_reg[7:1] <= data[511 -: 448] >> (64*0 + 63); // We will assign per element below
            // For simplicity, assign all boundaries from data here:
            // Since direct parallel assignment is complicated, assign in loop
            // We'll assign in a generate block below instead
        end else begin
            left_bounds_reg  <= left_bounds_next;
            right_bounds_reg <= right_bounds_next;
        end
    end

    // Handle initialization of boundary regs on load with a separate combinational logic
    // For load, we override boundary registers to match the loaded data boundaries
    // This requires some combinational logic and a multiplexer per bit
    // We'll implement combinational logic to select boundary registers as either load init or registered next

    wire [7:0] left_bounds_in;
    wire [7:0] right_bounds_in;

    generate
        for (i = 0; i < 8; i = i + 1) begin : boundaries_init_load
            // Left boundary per block:
            // block 0 left boundary = 0
            // blocks 1..7 left boundary = MSB of previous block's loaded data
            wire prev_block_msb = (i == 0) ? 1'b0 : data[(i*64)-1];
            assign left_bounds_in[i] = load ? prev_block_msb : left_bounds_next[i];

            // Right boundary per block:
            // block 7 right boundary = 0
            // blocks 0..6 right boundary = LSB of next block's loaded data
            wire next_block_lsb = (i == 7) ? 1'b0 : data[(i+1)*64];
            assign right_bounds_in[i] = load ? next_block_lsb : right_bounds_next[i];
        end
    endgenerate

    // Register boundary signals on clk with mux for load vs normal operation
    always @(posedge clk) begin
        left_bounds_reg  <= left_bounds_in;
        right_bounds_reg <= right_bounds_in;
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