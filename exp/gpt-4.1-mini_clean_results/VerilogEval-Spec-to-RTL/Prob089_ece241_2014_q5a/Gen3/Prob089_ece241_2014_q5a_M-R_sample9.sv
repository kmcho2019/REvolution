module TopModule (
    input  clk,
    input  areset,
    input  x,
    output wire z
);

    // State encoding
    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;
    reg x_reg;

    // Registers update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            state <= (state == S0 && x_reg == 1'b1) ? S1 : state;
            x_reg <= x;
        end
    end

    // Next state logic as a wire assigned combinationally (for clarity)
    wire next_state;
    assign next_state = (state == S0 && x_reg == 1'b1) ? S1 : state;

    // Output logic as a wire assigned combinationally (Moore output)
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule