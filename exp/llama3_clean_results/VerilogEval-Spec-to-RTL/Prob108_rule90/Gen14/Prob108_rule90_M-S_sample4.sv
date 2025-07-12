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
        // Apply Rule 90 directly
        assign next_state[i] = (i == 0) ? q_reg[i + 1] : (i == 511) ? q_reg[i - 1] : q_reg[i - 1] ^ q_reg[i + 1];
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