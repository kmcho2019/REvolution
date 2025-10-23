module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] shift_reg;  // Stores previous two bits

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            shift_reg <= 2'b00;
        end else begin
            shift_reg <= {shift_reg[0], x};
        end
    end

    // Mealy output: z=1 when we have '1' followed by '0' and current x is '1'
    assign z = (shift_reg == 2'b10) && x;

endmodule