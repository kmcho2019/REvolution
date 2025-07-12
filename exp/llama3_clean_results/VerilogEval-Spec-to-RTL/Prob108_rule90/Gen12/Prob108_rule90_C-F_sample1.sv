module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Combinational logic to compute the next state
wire [511:0] next_state;
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        // Boundary conditions
        if (i == 0) begin
            assign left = 1'b0; // Left boundary
            assign center = q_reg[i];
            assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
        end else if (i == 511) begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = 1'b0; // Right boundary
        end else begin
            assign left = q_reg[i - 1];
            assign center = q_reg[i];
            assign right = q_reg[i + 1];
        end
        // Apply Rule 90 logic
        assign next_state[i] = left ^ right; // No need to explicitly include center in XOR operation
    end
endgenerate

// Sequential logic to update the current state
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load data when load is high
    end else begin
        q_reg <= next_state; // Update state based on next_state when load is low
    end
end

assign q = q_reg; // Output the current state

endmodule