module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (~resetn) begin
        // Synchronous active-low reset
        shift_reg <= 4'b0000;
    end else begin
        // Shift the input into the first flip-flop and shift the rest of the register
        shift_reg <= {shift_reg[2:0], in};
    end
end

// The output is the output of the last flip-flop
assign out = shift_reg[3];

endmodule