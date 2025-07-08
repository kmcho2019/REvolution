module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {
        COPY = 1'b0,
        INVERT = 1'b1
    } state_t;

    state_t state, next_state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // output is based on current state and input
            case(state)
                COPY: begin
                    // Output is same as input before first '1'
                    z <= x;
                end
                INVERT: begin
                    // Output is inverted input after first '1'
                    z <= ~x;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            COPY: begin
                if (x == 1'b1)
                    next_state = INVERT;
                else
                    next_state = COPY;
            end
            INVERT: begin
                next_state = INVERT;
            end
            default: next_state = COPY;
        endcase
    end

endmodule