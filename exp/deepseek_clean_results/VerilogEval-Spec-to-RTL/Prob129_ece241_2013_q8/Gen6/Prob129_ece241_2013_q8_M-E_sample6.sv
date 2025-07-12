module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [2:0] shift_reg;

    always @(posedge clk or negedge aresetn)
        if (!aresetn) 
            shift_reg <= 3'b0;
        else 
            shift_reg <= {shift_reg[1:0], x};

    assign z = (shift_reg == 3'b101);

endmodule