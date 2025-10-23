module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [2:0] shift_reg;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 3'b000;
    end else begin
        shift_reg <= {shift_reg[1:0], x};
    end
end

// Output logic
assign z = (shift_reg == 3'b101);

endmodule