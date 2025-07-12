module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the Rule 110 lookup table
reg [0:0] rule110_table [0:7];

// Initialize the lookup table
initial begin
    // According to the Rule 110 table
    rule110_table[0] = 1'b0; // 000
    rule110_table[1] = 1'b1; // 001
    rule110_table[2] = 1'b1; // 010
    rule110_table[3] = 1'b1; // 011
    rule110_table[4] = 1'b0; // 100
    rule110_table[5] = 1'b1; // 101
    rule110_table[6] = 1'b1; // 110
    rule110_table[7] = 1'b0; // 111
end

// Combinational logic to compute the next state
always @(*) begin
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbor_states;
        if (i == 0) begin
            // Left neighbor is considered off for the first cell
            neighbor_states = {1'b0, current_state[i], (i + 1 < 512)? current_state[i + 1] : 1'b0};
        end else if (i == 511) begin
            // Right neighbor is considered off for the last cell
            neighbor_states = {current_state[i - 1], current_state[i], 1'b0};
        end else begin
            neighbor_states = {current_state[i - 1], current_state[i], current_state[i + 1]};
        end
        // Index the lookup table correctly based on neighbor_states
        next_state[i] = rule110_table[{neighbor_states[2], neighbor_states[1], neighbor_states[0]}];
    end
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule