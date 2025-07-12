module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] shift_reg;

    // Shift register implementation
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], x};
        end
    end

    // Mealy output - depends on current state (shift_reg) and input (x)
    assign z = (shift_reg == 3'b101) && x;

endmodule