module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] shift_reg;
reg [2:0] shift_count;
wire shift_enable = 1'b1; // Always enabled in basic mode

// Main shift operation
always @(posedge clk) begin
    if (shift_enable) begin
        shift_reg <= {d, shift_reg[7:1]};
        shift_count <= shift_count + 1;
    end
end

// Output assignment
assign q = shift_reg;

// Initialization
initial begin
    shift_reg = 8'b0;
    shift_count = 3'b0;
end

endmodule