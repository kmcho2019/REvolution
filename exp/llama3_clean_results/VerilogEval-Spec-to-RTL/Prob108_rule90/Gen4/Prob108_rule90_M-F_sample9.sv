module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        // Load the input data into the register
        q_reg <= data;
    end else begin
        // Update the register based on the rules of the automaton
        for (int i = 0; i < 512; i++) begin
            // Handle boundary conditions
            reg left;
            reg right;
            if (i == 0) begin
                left = 1'b0; // Left boundary is zero
                right = q_reg[i + 1];
            end else if (i == 511) begin
                left = q_reg[i - 1];
                right = 1'b0; // Right boundary is zero
            end else begin
                left = q_reg[i - 1];
                right = q_reg[i + 1];
            end
            
            // Apply the rule considering the neighbors
            // Rule 90: next state = left XOR right
            q_reg[i] <= left ^ right;
        end
    end
end

assign q = q_reg; // Output the current state

endmodule