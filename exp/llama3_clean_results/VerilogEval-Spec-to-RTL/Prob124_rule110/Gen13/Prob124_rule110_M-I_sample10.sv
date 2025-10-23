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
        reg [2:0] index;
        reg left, center, right;
        
        // Determine the states of the neighbors
        left = (i == 0) ? 1'b0 : current_state[i - 1];
        center = current_state[i];
        right = (i == 511) ? 1'b0 : current_state[i + 1];
        
        // Calculate the index directly from left, center, right
        index = {left, center, right};
        
        // Use the index to determine the next state
        next_state[i] = rule110_table[index]; // Corrected index usage
    end
end

// Sequential logic to update the current state with clock gating
reg clk_enable;
always @(*) begin
    clk_enable = ~load; // Enable clock when not loading
end

always @(posedge clk) begin
    if (clk_enable) begin
        current_state <= next_state;
    end else if (load) begin
        current_state <= data;
    end
end

assign q = current_state;

endmodule