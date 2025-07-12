module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam S0 = 1'b0; // Waiting for first '1'
    localparam S1 = 1'b1; // Inverting subsequent bits

    reg state;
    reg x_reg;

    // Synchronous process: state and input bit register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            state <= (state == S0 && x_reg == 1'b1) ? S1 : state;
            x_reg <= x;
        end
    end

    // Moore output combinational logic, purely based on registered signals
    assign z = (state == S0) ? x_reg : ~x_reg;

endmodule