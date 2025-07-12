module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

// Explicitly declare out as a wire for clarity
wire out;

// reg type is already used for shift_reg, which is appropriate
reg [3:0] shift_reg;

always @(posedge clk) begin
    if (!resetn) begin
        // Synchronous reset
        shift_reg <= 4'b0000;
    end else begin
        // Shift operation, which is already fairly efficient
        shift_reg <= {shift_reg[2:0], in};
    end
end

// Continuous assignment for out
assign out = shift_reg[3];

endmodule