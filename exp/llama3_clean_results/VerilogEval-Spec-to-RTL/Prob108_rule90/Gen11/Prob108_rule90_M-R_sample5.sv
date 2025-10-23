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
        assign left = (i == 0) ? 1'b0 : q_reg[i - 1]; // Handle left boundary
        assign center = q_reg[i];
        assign right = (i == 511) ? 1'b0 : q_reg[i + 1]; // Handle right boundary
        // Apply Rule 90 logic
        assign next_state[i] = left ^ right; // No need to explicitly include center in XOR operation
    end
endgenerate

// Update q_reg based on load and calculated next states
always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        q_reg <= next_state; // Update with calculated next states
    end
end

assign q = q_reg; // Output the current state

endmodule