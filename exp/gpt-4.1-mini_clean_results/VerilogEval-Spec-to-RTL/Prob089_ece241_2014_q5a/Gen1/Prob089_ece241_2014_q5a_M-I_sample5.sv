module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    // State encoding
    typedef enum logic [0:0] {
        S0 = 1'b0,
        S1 = 1'b1
    } state_t;

    state_t current_state, next_state;
    reg x_reg; // Registered input bit for output generation

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            x_reg <= 1'b0;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            x_reg <= x;

            // Moore output depends only on state and registered bit
            case (current_state)
                S0: z <= x_reg;       // output equals registered input before first '1'
                S1: z <= ~x_reg;      // output inverted registered input after first '1'
                default: z <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (x == 1'b1)
                    next_state = S1;
                else
                    next_state = S0;
            end
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

endmodule