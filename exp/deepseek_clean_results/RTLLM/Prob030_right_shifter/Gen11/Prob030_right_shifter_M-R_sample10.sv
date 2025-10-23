module right_shifter (
    input wire clk,
    input wire d,
    input wire enable,
    output wire [7:0] q
);

// Clock gating implementation
wire gated_clk = clk & enable;

// Register storage
reg [7:0] shift_reg;

// Combinational shift operation
assign q = shift_reg;

// Sequential update
always @(posedge gated_clk) begin
    shift_reg <= {d, shift_reg[7:1]};
end

initial begin
    shift_reg = 8'b0;
end

endmodule