module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Combinational logic to calculate next state
wire [511:0] next_state;

assign next_state[0] = q_reg[1]; // Left neighbor is 0
assign next_state[511] = q_reg[510]; // Right neighbor is 0

// Unrolled loop to calculate next state for internal cells
generate
    for (genvar i = 1; i < 511; i++) begin
        assign next_state[i] = q_reg[i-1] ^ q_reg[i+1];
    end
endgenerate

// Sequential logic to update state registers
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule