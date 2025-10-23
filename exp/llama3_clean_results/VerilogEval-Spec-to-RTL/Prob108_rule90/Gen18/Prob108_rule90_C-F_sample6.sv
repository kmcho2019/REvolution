module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic to calculate the next state of each cell
wire [511:0] next_state;

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        // Explicit boundary conditions for clarity and potential synthesis optimization
        assign left = (i == 0) ? 1'b0 : q_reg[i - 1];
        assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
        
        // Apply Rule 90 logic directly without needing additional variables
        assign next_state[i] = left ^ right;
    end
endgenerate

// Sequential logic to update q_reg on the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        // Update q_reg directly with next_state for simplicity and efficiency
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule