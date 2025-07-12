module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], x};
    end
end

// Output logic
assign z = (shift_reg == 2'b10 && x == 1'b1);

endmodule