module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam COPY   = 1'b0;  // Output input bits directly until first '1'
    localparam INVERT = 1'b1;  // Output inverted bits after first '1'

    reg state, next_state;
    reg x_reg;

    // Register input, state and output with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
            case (state)
                COPY:   z <= x_reg;
                INVERT: z <= ~x_reg;
                default: z <= 1'b0;
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            COPY:   next_state = (x_reg == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

endmodule