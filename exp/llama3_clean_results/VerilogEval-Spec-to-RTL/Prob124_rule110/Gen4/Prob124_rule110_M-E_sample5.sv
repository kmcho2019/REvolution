module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Define the Rule 110 lookup table
reg [0:0] rule110_lookup_table[0:255];

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
    for (int i = 0; i < 256; i++) begin
        reg [2:0] neighbor_values;
        neighbor_values = i;
        if (neighbor_values == 3'b111) begin
            rule110_lookup_table[i] = 1'b0;
        end else if (neighbor_values == 3'b110) begin
            rule110_lookup_table[i] = 1'b1;
        end else if (neighbor_values == 3'b101) begin
            rule110_lookup_table[i] = 1'b1;
        end else if (neighbor_values == 3'b100) begin
            rule110_lookup_table[i] = 1'b0;
        end else if (neighbor_values == 3'b011) begin
            rule110_lookup_table[i] = 1'b1;
        end else if (neighbor_values == 3'b010) begin
            rule110_lookup_table[i] = 1'b1;
        end else if (neighbor_values == 3'b001) begin
            rule110_lookup_table[i] = 1'b1;
        end else begin
            rule110_lookup_table[i] = 1'b0;
        end
    end
end

// Calculate next state using lookup table
always @(*) begin
    next_state = 0;
    for (int i = 0; i < 512; i++) begin
        reg [2:0] neighbor_values;
        reg left, center, right;
        // Handle boundary conditions
        if (i == 0) begin
            left = 0;
        end else begin
            left = current_state[i-1];
        end
        if (i == 511) begin
            right = 0;
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