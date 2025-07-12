module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] shift_reg;

    // Shift register implementation with async reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[1:0], x};
        end
    end

    // Output is high when shift register contains "101"
    assign z = (shift_reg == 3'b101);

endmodule