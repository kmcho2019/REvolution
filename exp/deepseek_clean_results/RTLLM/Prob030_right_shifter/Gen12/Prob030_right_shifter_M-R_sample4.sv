module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,  // Clock gating control
    output wire [7:0] q
);

// Internal wires
wire [7:0] next_q;
wire gated_clk;

// Clock gating implementation
assign gated_clk = clk & enable;

// Combinational shift logic
assign next_q = {d, q[7:1]};  // Right shift with new bit insertion

// Sequential element (explicit register)
reg [7:0] q_reg;
assign q = q_reg;

always @(posedge gated_clk) begin
    q_reg <= next_q;
end

endmodule