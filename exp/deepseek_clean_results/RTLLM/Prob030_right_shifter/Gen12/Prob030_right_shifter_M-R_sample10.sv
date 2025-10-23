module right_shifter (
    input clk,
    input d,
    output [7:0] q
);

reg [7:0] q_reg = 8'b0;
wire [7:0] shifted_val;

// Combinational shift operation
assign shifted_val = {d, q_reg[7:1]};

// Sequential register update
always @(posedge clk) begin
    q_reg <= shifted_val;
end

// Output assignment
assign q = q_reg;

endmodule