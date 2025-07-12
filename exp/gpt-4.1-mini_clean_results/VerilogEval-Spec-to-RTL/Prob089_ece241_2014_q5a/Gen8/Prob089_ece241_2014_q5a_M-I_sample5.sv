module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    // State encoding
    localparam WAIT_FOR_ONE = 1'b0;  // Copy input until first '1' detected
    localparam INVERTING    = 1'b1;  // Invert bits after first '1'

    reg state;
    reg x_reg;

    // Sequential logic with asynchronous reset
    // Update x_reg only when state is WAIT_FOR_ONE to reduce unnecessary toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_ONE;
            x_reg <= 1'b0;
        end else begin
            case (state)
                WAIT_FOR_ONE: begin
                    x_reg <= x;
                    state <= (x_reg == 1'b1) ? INVERTING : WAIT_FOR_ONE;
                end
                INVERTING: begin
                    state <= INVERTING;
                end
                default: begin
                    state <= WAIT_FOR_ONE;
                end
            endcase
        end
    end

    // Moore output as continuous assignment for better synthesis and timing
    assign z = (state == WAIT_FOR_ONE) ? x_reg : ~x_reg;

endmodule