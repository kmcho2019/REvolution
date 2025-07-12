module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;
reg [511:0] next_state;

// Simplified combinational logic to calculate next_state
always @* begin
    for (int i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) left = 0; else left = q_reg[i - 1];
        center = q_reg[i];
        if (i == 511) right = 0; else right = q_reg[i + 1];
        
        // Simplified next state calculation using direct binary logic
        // The following line calculates the next state based on Rule 110's truth table
        // It can be derived by analyzing the table and finding a pattern that can be expressed in binary logic
        next_state[i] = ~(left & center & right) & (center | right | (left & ~center));
    end
end

// Sequential logic to update q_reg, minimizing unnecessary updates
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Only update q_reg if next_state is different, to reduce switching activity
        if (next_state != q_reg) begin
            q_reg <= next_state;
        end
    end
end

assign q = q_reg;

endmodule