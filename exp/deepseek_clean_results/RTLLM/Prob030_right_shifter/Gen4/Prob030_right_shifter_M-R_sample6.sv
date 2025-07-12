module right_shifter (
    input wire clk,
    input wire d,
    output wire [7:0] q
);

reg [7:0] shift_reg;
reg initialized = 1'b0;

// Combinational shift logic
assign q = (initialized) ? {d, shift_reg[7:1]} : 8'b0;

// Sequential register update
always @(posedge clk) begin
    if (!initialized) begin
        initialized <= 1'b1;
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {d, shift_reg[7:1]};
    end
end

endmodule