module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

// Calculate next state for each cell
wire [511:0] next_state;
assign next_state[0] = q_reg[1]; // Left neighbor of q[0] is always 0
assign next_state[511] = q_reg[510]; // Right neighbor of q[511] is always 0

// Calculate next state for cells 1 through 510
generate
    for (genvar i = 1; i < 511; i++) begin
        assign next_state[i] = q_reg[i-1] ^ q_reg[i+1];
    end
endgenerate

// Update state register based on load signal
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule