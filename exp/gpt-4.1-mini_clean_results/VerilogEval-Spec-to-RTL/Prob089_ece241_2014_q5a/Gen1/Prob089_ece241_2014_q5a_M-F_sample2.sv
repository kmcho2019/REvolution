module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // States
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state;
    reg x_reg;      // Registered input

    // State and input register update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            x_reg <= x;
            case(state)
                COPY: begin
                    z <= x_reg;             // Output input bit directly
                    if (x_reg == 1'b1)
                        state <= INVERT;
                    else
                        state <= COPY;
                end
                INVERT: begin
                    z <= ~x_reg;            // Output inverted input bit
                    state <= INVERT;        // Remain in INVERT
                end
                default: begin
                    state <= COPY;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule