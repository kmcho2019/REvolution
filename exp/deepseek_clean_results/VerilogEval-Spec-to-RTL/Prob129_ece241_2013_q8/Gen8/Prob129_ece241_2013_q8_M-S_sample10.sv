module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] shift_reg;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            shift_reg <= 2'b00;
        else
            shift_reg <= {shift_reg[0], x};
    end

    assign z = (shift_reg == 2'b10) && x;

endmodule