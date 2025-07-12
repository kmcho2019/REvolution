module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= {shift_reg[0], x};
    end
end

// Output logic with reduced switching activity
reg prev_shift_reg;
always @(posedge clk) begin
    prev_shift_reg <= shift_reg;
end

assign z = (prev_shift_reg == 2'b10) && x;

endmodule