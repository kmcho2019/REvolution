module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] shift_reg;

// Combinational logic
wire next_shift_reg;
assign next_shift_reg = {shift_reg[0], x};

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        shift_reg <= 2'b00;
    end else begin
        shift_reg <= next_shift_reg;
    end
end

// Output logic
assign z = (shift_reg == 2'b10) && x;

endmodule