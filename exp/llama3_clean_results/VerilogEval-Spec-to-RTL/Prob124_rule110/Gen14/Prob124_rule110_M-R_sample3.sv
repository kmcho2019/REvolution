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

// Continuous assignment for combinational logic
genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        
        // Handle boundary conditions
        assign left = (i == 0) ? 1'b0 : current_state[i-1];
        assign center = current_state[i];
        assign right = (i == 511) ? 1'b0 : current_state[i+1];
        
        // Apply Rule 110 logic
        // The logic here is based on the truth table provided, converted into a single line for efficiency.
        // It directly implements the rule based on the states of the left, center, and right cells.
        assign next_state[i] = (left && center && !right) || 
                               (!left && center && !right) || 
                               (!left && !center && right) || 
                               (!left && !center && !right);
    end
endgenerate

assign q = current_state;

endmodule