module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [511:0] next_state;
        
        // Handle boundary conditions explicitly
        next_state[0] = q_reg[1]; // Left neighbor is always 0, so XOR with right neighbor
        next_state[511] = q_reg[510]; // Right neighbor is always 0, so XOR with left neighbor
        
        // Calculate next state for middle cells
        for (genvar i = 1; i < 511; i++) begin
            assign next_state[i] = q_reg[i-1] ^ q_reg[i+1];
        end
        
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule