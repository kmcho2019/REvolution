module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    typedef enum logic [1:0] {
        IDLE   = 2'b00,
        COPY   = 2'b01,
        INVERT = 2'b10
    } state_t;

    state_t state, next_state;
    reg next_z;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

    // Next state and output logic (Moore output: output depends on state and input)
    always @(*) begin
        next_state = state;
        next_z = 1'b0;

        case(state)
            IDLE: begin
                // When reset released, start conversion
                // Output zero while in IDLE
                next_z = 1'b0;
                next_state = COPY;
            end
            COPY: begin
                next_z = x; // output equals input bit
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                next_z = ~x; // output bitwise inverted input
                next_state = INVERT;
            end
            default: begin
                next_state = IDLE;
                next_z = 1'b0;
            end
        endcase
    end

endmodule