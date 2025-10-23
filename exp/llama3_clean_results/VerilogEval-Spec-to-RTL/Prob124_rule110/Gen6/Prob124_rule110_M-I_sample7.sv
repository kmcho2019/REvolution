module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the Rule 110 lookup table
reg [0:0] rule110_lookup_table[0:7];

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

// Initialize the lookup table
initial begin
    rule110_lookup_table[0] = 1'b0; // 000
    rule110_lookup_table[1] = 1'b1; // 001
    rule110_lookup_table[2] = 1'b1; // 010
    rule110_lookup_table[3] = 1'b0; // 011
    rule110_lookup_table[4] = 1'b1; // 100
    rule110_lookup_table[5] = 1'b1; // 101
    rule110_lookup_table[6] = 1'b1; // 110
    rule110_lookup_table[7] = 1'b0; // 111
end

// Calculate next state using lookup table
always @(posedge clk) begin
    next_state = current_state; // Initialize next_state with current_state
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbor_values;
        reg left, center, right;
        
        // Handle boundary conditions
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = current_state[i-1];
        end
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = current_state[i+1];
        end
        center = current_state[i];

        // Pack neighbor values into a 3-bit value
        neighbor_values = {left, center, right};

        // Index into the lookup table to retrieve the next state
        next_state[i] = rule110_lookup_table[neighbor_values];
    end
end

endmodule