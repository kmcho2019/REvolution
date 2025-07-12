module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] shift_reg;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
        z <= 1'b0;
    end else begin
        shift_reg <= {shift_reg[0], x};
        z <= (shift_reg == 2'b10) && x;
    end
end

endmodule