module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q_reg;
wire [7:0] q_next;

// Combinational next-state logic
assign q_next = {d, q_reg[7:1]};

// Sequential element
always @(posedge clk) begin
    q_reg <= q_next;
end

// Output assignment
assign q = q_reg;

endmodule