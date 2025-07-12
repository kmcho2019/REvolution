module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE         = 2'b00, // When reset is active
        PASS_THROUGH = 2'b01, // Before first '1'
        INVERT       = 2'b10  // After first '1'
    } state_t;

    state_t state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // Reset released, start conversion
                    state <= PASS_THROUGH;
                    z <= x; // Output input bit until first '1'
                end
                PASS_THROUGH: begin
                    z <= x;
                    if (x == 1'b1)
                        state <= INVERT;
                end
                INVERT: begin
                    z <= ~x;
                    // Remain in INVERT state
                end
                default: begin
                    state <= IDLE;
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule