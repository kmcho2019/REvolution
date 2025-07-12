module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam WAIT_FOR_ONE = 1'b0;
    localparam INVERTING    = 1'b1;

    reg state;
    reg x_reg;

    // Sequential logic: input sampling and state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_ONE;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            state <= (state == WAIT_FOR_ONE && x_reg == 1'b1) ? INVERTING : state;
        end
    end

    // Output logic as continuous assignment for improved synthesis
    assign z = (state == WAIT_FOR_ONE) ? x_reg : ~x_reg;

endmodule