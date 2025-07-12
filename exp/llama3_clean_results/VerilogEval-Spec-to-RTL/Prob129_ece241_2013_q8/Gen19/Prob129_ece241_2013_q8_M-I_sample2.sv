module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], x};
    end
end

// Simplified condition for z to minimize combinational logic
assign z = (shift_reg == 2'b10 && x) ? 1'b1 : 1'b0;

endmodule