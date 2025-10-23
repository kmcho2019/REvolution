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

    // Register input 'x' asynchronously reset to 0
    always @(posedge clk or posedge areset) begin
        if (areset)
            x_reg <= 1'b0;
        else
            x_reg <= x;
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WAIT_FOR_ONE;
        else if (state == WAIT_FOR_ONE && x_reg == 1'b1)
            state <= INVERTING;
        else
            state <= state; // Hold state otherwise
    end

    // Continuous assignment for Moore output based on state and registered input
    assign z = (state == WAIT_FOR_ONE) ? x_reg : ~x_reg;

endmodule