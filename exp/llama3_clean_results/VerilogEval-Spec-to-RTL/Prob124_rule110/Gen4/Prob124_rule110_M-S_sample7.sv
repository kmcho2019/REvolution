module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

// Lookup table for Rule 110
reg [0:0] rule110_lookup_table[2**3-1:0];
initial begin
    rule110_lookup_table[0] = 0; // 000
    rule110_lookup_table[1] = 0; // 001
    rule110_lookup_table[2] = 0; // 010
    rule110_lookup_table[3] = 0; // 011
    rule110_lookup_table[4] = 1; // 100
    rule110_lookup_table[5] = 1; // 101
    rule110_lookup_table[6] = 1; // 110
    rule110_lookup_table[7] = 0; // 111
end

// Calculate next state using lookup table
always @(*) begin
    next_state = 0;
    for (int i = 0; i < 512; i++) begin
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

        // Compute next state using lookup table
        reg [2:0] index = {left, center, right};
        next_state[i] = rule110_lookup_table[index];
    end
end

endmodule