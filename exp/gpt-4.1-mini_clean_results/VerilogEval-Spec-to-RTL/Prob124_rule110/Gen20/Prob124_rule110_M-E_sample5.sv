module NeighborExtractor512 (
    input  wire         clk,
    input  wire [511:0] state_in,
    output reg  [1535:0] neighbors_out // 512 cells * 3 bits = 1536 bits
);
    // Pad input state with zero on both ends for boundary conditions
    wire [513:0] padded_state = {1'b0, state_in, 1'b0};

    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 512; i = i + 1) begin
            neighbors_out[3*i +: 3] <= {padded_state[i+2], padded_state[i+1], padded_state[i]};
            // neighbors_out[3*i+2] = left neighbor
            // neighbors_out[3*i+1] = center
            // neighbors_out[3*i]   = right neighbor
        end
    end
endmodule

module NextStateCalc512 (
    input  wire          clk,
    input  wire [1535:0] neighbors_in, // 512 * 3 bits
    output reg  [511:0]  next_state_out
);
    integer i;
    always @(posedge clk) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Extract the triplet (left, center, right)
            // Using the exact bit order from NeighborExtractor: {L,C,R}
            // Encode as 3-bit vector: {L, C, R}
            case (neighbors_in[3*i +: 3])
                3'b111: next_state_out[i] <= 1'b0; // 111 -> 0
                3'b110: next_state_out[i] <= 1'b1; // 110 -> 1
                3'b101: next_state_out[i] <= 1'b1; // 101 -> 1
                3'b100: next_state_out[i] <= 1'b0; // 100 -> 0
                3'b011: next_state_out[i] <= 1'b1; // 011 -> 1
                3'b010: next_state_out[i] <= 1'b1; // 010 -> 1
                3'b001: next_state_out[i] <= 1'b1; // 001 -> 1
                3'b000: next_state_out[i] <= 1'b0; // 000 -> 0
                default: next_state_out[i] <= 1'b0; // default safety (should not happen)
            endcase
        end
    end
endmodule

module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    // Internal registers for pipeline stages
    reg [511:0] state_reg;            // Holds current state
    reg [1535:0] neighbors_reg;       // Holds neighbors extracted from state_reg
    reg [511:0] next_state_reg;       // Holds next state computed from neighbors_reg

    // Instantiate combinational neighbor extraction and next state calculation done in sequential stages
    // Here, we emulate pipeline stages manually via registers updated each clock

    // Stage 1: neighbor extraction - done combinationally inside an always block on posedge clk
    // Since neighbors_reg and next_state_reg are only registers, the logic is in this module
    
    integer i;
    wire [513:0] padded_state = {1'b0, state_reg, 1'b0};

    // Neighbor extraction combinational logic
    wire [1535:0] neighbors_comb;
    generate
        genvar gi;
        for (gi = 0; gi < 512; gi = gi + 1) begin : gen_neighbors
            assign neighbors_comb[3*gi + 2] = padded_state[gi + 2];   // left
            assign neighbors_comb[3*gi + 1] = padded_state[gi + 1];   // center
            assign neighbors_comb[3*gi + 0] = padded_state[gi];       // right
        end
    endgenerate

    // Next state calculation combinational logic
    reg [511:0] next_state_comb;
    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            case (neighbors_reg[3*i +: 3])
                3'b111: next_state_comb[i] = 1'b0;
                3'b110: next_state_comb[i] = 1'b1;
                3'b101: next_state_comb[i] = 1'b1;
                3'b100: next_state_comb[i] = 1'b0;
                3'b011: next_state_comb[i] = 1'b1;
                3'b010: next_state_comb[i] = 1'b1;
                3'b001: next_state_comb[i] = 1'b1;
                3'b000: next_state_comb[i] = 1'b0;
                default: next_state_comb[i] = 1'b0;
            endcase
        end
    end

    // Sequential logic to implement pipeline with load
    always @(posedge clk) begin
        if (load) begin
            // Loading overrides pipeline: load input data directly to state
            state_reg <= data;
            neighbors_reg <= {1536{1'b0}}; // clear neighbors pipeline stage
            next_state_reg <= 512'b0;      // clear next state pipeline stage
            q <= data;
        end else begin
            // Advance pipeline
            neighbors_reg <= neighbors_comb;
            next_state_reg <= next_state_comb;
            state_reg <= next_state_reg;
            q <= state_reg;
        end
    end

endmodule