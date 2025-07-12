module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [2:0] shift_reg;

always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= 3'b000;
    end else begin
        shift_reg <= {x, shift_reg[2:1]};
    end
end

assign z = (shift_reg == 3'b101);

endmodule