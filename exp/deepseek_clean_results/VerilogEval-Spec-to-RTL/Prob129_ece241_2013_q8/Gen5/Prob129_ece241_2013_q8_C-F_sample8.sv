module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state_reg;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) state_reg <= 2'b0;
        else state_reg <= {state_reg[0], x};

    assign z = (state_reg == 2'b10) & x;

endmodule