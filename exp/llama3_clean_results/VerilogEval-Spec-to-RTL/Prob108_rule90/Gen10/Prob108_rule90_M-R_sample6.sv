module Rule90NextState(
    input  [511:0] current_state,
    output [511:0] next_state
);

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, right;
        if (i == 0) begin
            assign left = 1'b0; // Left boundary
            assign right = current_state[i + 1];
        end else if (i == 511) begin
            assign left = current_state[i - 1];
            assign right = 1'b0; // Right boundary
        end else begin
            assign left = current_state[i - 1];
            assign right = current_state[i + 1];
        end
        assign next_state[i] = left ^ right; // Rule 90: XOR of left and right
    end
endgenerate

endmodule

module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

Rule90NextState next_state_calc (
   .current_state(q_reg),
   .next_state(next_state)
);

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