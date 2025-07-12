module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q_reg = 0;
wire [7:0] next_q;

// Combinational logic for shift operation
assign next_q = {d, q_reg[7:1]};

// Sequential logic for register update
always @(posedge clk) begin
    q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule