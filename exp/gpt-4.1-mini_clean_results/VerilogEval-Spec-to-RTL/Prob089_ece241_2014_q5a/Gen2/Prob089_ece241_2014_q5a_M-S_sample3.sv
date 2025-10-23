module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    localparam BEFORE_FIRST_ONE = 1'b0;
    localparam AFTER_FIRST_ONE  = 1'b1;

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= BEFORE_FIRST_ONE;
            z <= 1'b0;
        end else begin
            case (state)
                BEFORE_FIRST_ONE: begin
                    z <= x;             // Output same bit until first '1'
                    if (x == 1'b1)
                        state <= AFTER_FIRST_ONE;
                end
                AFTER_FIRST_ONE: begin
                    z <= ~x;            // Invert bits after first '1'
                    // Stay in AFTER_FIRST_ONE
                end
            endcase
        end
    end

endmodule