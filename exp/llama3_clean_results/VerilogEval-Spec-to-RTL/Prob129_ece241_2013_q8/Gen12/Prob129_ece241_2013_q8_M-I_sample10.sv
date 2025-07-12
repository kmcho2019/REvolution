module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the state register
reg [1:0] shift_reg;

// Asynchronous reset and sequential logic
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        // Reset the shift register on asynchronous reset
        shift_reg <= 2'b00;
    end else begin
        // Shift in the new input on the positive clock edge
        shift_reg <= {shift_reg[0], x};
    end
end

// Output logic: Assert z when the shift register contains "10" and the current input is "1"
assign z = (shift_reg == 2'b10) && x;

endmodule