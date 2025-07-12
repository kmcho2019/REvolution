module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the shift register length
localparam SHIFT_REG_LENGTH = 3;

// Initialize the shift register
reg [SHIFT_REG_LENGTH-1:0] shift_reg;

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        shift_reg <= '0;
    end else begin
        shift_reg <= {shift_reg[SHIFT_REG_LENGTH-2:0], x};
    end
end

// Output logic
assign z = (shift_reg == 3'b101);

endmodule