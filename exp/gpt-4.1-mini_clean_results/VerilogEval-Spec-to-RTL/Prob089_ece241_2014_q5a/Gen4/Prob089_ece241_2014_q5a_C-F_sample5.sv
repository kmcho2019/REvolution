module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding using typedef enum for clarity
    typedef enum logic [0:0] {
        WAIT_FOR_FIRST_ONE = 1'b0,
        INVERT_BITS        = 1'b1
    } state_t;

    state_t state, next_state;
    reg x_reg;

    // Register input x and state with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WAIT_FOR_FIRST_ONE;
            x_reg <= 1'b0;
        end else begin
            state <= next_state;
            x_reg <= x;
        end
    end

    // Next state logic based on registered input x_reg and current state
    always @(*) begin
        case (state)
            WAIT_FOR_FIRST_ONE: begin
                if (x_reg == 1'b1)
                    next_state = INVERT_BITS;
                else
                    next_state = WAIT_FOR_FIRST_ONE;
            end
            INVERT_BITS: begin
                next_state = INVERT_BITS;
            end
            default: next_state = WAIT_FOR_FIRST_ONE;
        endcase
    end

    // Moore output registered on clock edge or async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            case (state)
                WAIT_FOR_FIRST_ONE: z <= x_reg;
                INVERT_BITS:        z <= ~x_reg;
                default:            z <= 1'b0;
            endcase
        end
    end

endmodule