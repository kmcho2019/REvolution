module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    typedef enum logic [0:0] {
        WAIT_FOR_FIRST_ONE = 1'b0,
        INVERT_BITS        = 1'b1
    } state_t;

    state_t state, next_state;
    reg     next_z;

    // Combinational logic: next state and next output
    always @(*) begin
        case(state)
            WAIT_FOR_FIRST_ONE: begin
                if (x == 1'b1) begin
                    next_state = INVERT_BITS;
                    next_z = x;
                end else begin
                    next_state = WAIT_FOR_FIRST_ONE;
                    next_z = x;
                end
            end
            INVERT_BITS: begin
                next_state = INVERT_BITS;
                next_z = ~x;
            end
            default: begin
                next_state = WAIT_FOR_FIRST_ONE;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic: state and output registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_FIRST_ONE;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule