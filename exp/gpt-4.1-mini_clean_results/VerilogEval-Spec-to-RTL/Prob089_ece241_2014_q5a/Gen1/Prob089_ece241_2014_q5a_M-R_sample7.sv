module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    localparam COPY   = 1'b0;
    localparam INVERT = 1'b1;

    reg state, next_state;
    reg x_reg;  // Registered input to break combinational dependency on input

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Next state logic based on registered input x_reg
    always @(*) begin
        case (state)
            COPY:   next_state = (x_reg == 1'b1) ? INVERT : COPY;
            INVERT: next_state = INVERT;
            default: next_state = COPY;
        endcase
    end

    // Output logic: registered Moore output depending only on state and registered input
    // For COPY: output equals the registered input bit (copied)
    // For INVERT: output equals inverted registered input bit
    always @(posedge clk or posedge areset) begin
        if (areset)
            z <= 1'b0;
        else begin
            case (state)
                COPY:   z <= x_reg;
                INVERT: z <= ~x_reg;
                default: z <= 1'b0;
            endcase
        end
    end

endmodule