module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    reg inversion_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            inversion_state <= 1'b0;
        else if (inversion_state == 1'b0 && x == 1'b1)
            inversion_state <= 1'b1;
        else
            inversion_state <= inversion_state;
    end

    assign z = x ^ inversion_state;

endmodule