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
        shift_reg <= {x, shift_reg[1]};
    end
end

// Output logic
assign z = (shift_reg == 2'b10 && x) || (shift_reg == 2'b01 && x);

endmodule