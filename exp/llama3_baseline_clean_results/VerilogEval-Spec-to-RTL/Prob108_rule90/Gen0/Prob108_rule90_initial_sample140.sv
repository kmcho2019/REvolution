module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Internal register to store the current state

always @(posedge clk) begin
    if (load) begin
        // Load data into the register when load is high
        q_reg <= data;
    end else begin
        // Calculate the next state of each cell based on the current state of its neighbors
        reg [511:0] next_state;
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            if (i == 0) begin
                left = 0; // Left boundary is always zero
            end else begin
                left = q_reg[i-1];
            end
            center = q_reg[i];
            if (i == 511) begin
                right = 0; // Right boundary is always zero
            end else begin
                right = q_reg[i+1];
            end
            next_state[i] = left ^ right; // XOR of left and right neighbors
        end
        q_reg <= next_state;
    end
end

// Continuous assignment to output q
assign q = q_reg;

endmodule