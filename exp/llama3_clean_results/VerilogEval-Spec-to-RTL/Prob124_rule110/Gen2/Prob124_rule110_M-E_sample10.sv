module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

// Lookup table for Rule 110
reg [1:0] lookup_table [7:0];

initial begin
    // Initialize lookup table for Rule 110
    lookup_table[7] = 0; // 1 1 1 -> 0
    lookup_table[6] = 1; // 1 1 0 -> 1
    lookup_table[5] = 1; // 1 0 1 -> 1
    lookup_table[4] = 0; // 1 0 0 -> 0
    lookup_table[3] = 1; // 0 1 1 -> 1
    lookup_table[2] = 1; // 0 1 0 -> 1
    lookup_table[1] = 1; // 0 0 1 -> 1
    lookup_table[0] = 0; // 0 0 0 -> 0
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg [2:0] neighbors;
            if (i == 0) begin
                neighbors[2] = 0;
            end else begin
                neighbors[2] = current_state[i-1];
            end
            neighbors[1] = current_state[i];
            if (i == 511) begin
                neighbors[0] = 0;
            end else begin
                neighbors[0] = current_state[i+1];
            end
            
            // Use lookup table to determine next state
            next_state[i] <= lookup_table[neighbors];
        end
        current_state <= next_state;
        q <= next_state;
    end
end

endmodule