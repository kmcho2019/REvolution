module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    localparam S0 = 1'b0; // waiting for first '1' (carry not started)
    localparam S1 = 1'b1; // inverting subsequent bits (carry started)

    reg state;
    reg x_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_reg <= 1'b0;
        end else begin
            x_reg <= x;
            case (state)
                S0: state <= (x_reg) ? S1 : S0;
                S1: state <= S1;
            endcase
        end
    end

    always @(*) begin
        z = (state == S0) ? x_reg : ~x_reg;
    end

endmodule