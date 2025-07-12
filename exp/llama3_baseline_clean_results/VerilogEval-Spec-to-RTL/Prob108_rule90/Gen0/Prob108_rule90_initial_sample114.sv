module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to hold the current state of the cells

// Initialize output q with the value of q_reg
assign q = q_reg;

// Combinational logic to calculate the next state of each cell
always @(*) begin
    reg [511:0] next_state;
    for (int i = 0; i < 512; i++) begin
        // Apply Rule 90 for each cell
        // Left neighbor (for i = 0, left neighbor is always 0)
        reg left;
        if (i == 0) begin
            left = 1'b0;
        end else begin
            left = q_reg[i-1];
        end

        // Right neighbor (for i = 511, right neighbor is always 0)
        reg right;
        if (i == 511) begin
            right = 1'b0;
        end else begin
            right = q_reg[i+1];
        end

        next_state[i] = left ^ right ^ q_reg[i];
    end
    // Update q_reg with next_state on positive edge of clock
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

// Add a clock edge trigger to the always block to ensure q_reg only updates on positive clock edge
always @(posedge clk) begin
    // No need to do anything here, as the update logic is handled in the combinational always block
end

endmodule