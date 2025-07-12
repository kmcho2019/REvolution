module TopModule (
    input clk,
    input reset,
    output [4:0] q
);

wire [4:0] next_q;

// Combinational logic for LFSR next state
assign next_q = {q[0], q[4], q[3] ^ q[0], q[2], q[1]};

// Sequential logic with synchronous reset
reg [4:0] q_reg;
always @(posedge clk) begin
    q_reg <= reset ? 5'b00001 : next_q;
end

assign q = q_reg;

endmodule