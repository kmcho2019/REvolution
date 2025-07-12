module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg x_reg;
    reg z_next;

    // State register and input register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
            z     <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
            z     <= z_next;
        end
    end

    // Next state logic: depends on registered input and current state
    always @(*) begin
        case (state)
            COPY:   next_state = (x_reg == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Moore output logic: combinational, depends only on registered state and input
    always @(*) begin
        case (state)
            COPY:   z_next = x_reg;
            INVERT: z_next = ~x_reg;
            default: z_next = 1'b0;
        endcase
    end

endmodule