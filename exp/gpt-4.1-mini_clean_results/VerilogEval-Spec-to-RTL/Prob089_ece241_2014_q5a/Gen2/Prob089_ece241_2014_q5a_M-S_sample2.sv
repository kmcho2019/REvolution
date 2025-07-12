module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam WAIT   = 1'b0;
    localparam INVERT = 1'b1;

    reg state;
    reg x_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            x_reg <= x;
            case (state)
                WAIT: begin
                    z <= x_reg;
                    if (x_reg == 1'b1)
                        state <= INVERT;
                end
                INVERT: begin
                    z <= ~x_reg;
                    // remain in INVERT
                end
            endcase
        end
    end

endmodule