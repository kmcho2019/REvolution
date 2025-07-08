module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    // State encoding
    typedef enum logic [0:0] {S0=1'b0, S1=1'b1} state_t;
    state_t state, next_state;

    reg x_d; // delayed input for Moore output

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S0;
            x_d <= 1'b0;
        end else begin
            state <= next_state;
            x_d <= x;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (x) ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Moore output logic: output depends on state and delayed input only
    always @(*) begin
        case (state)
            S0: z = x_d;       // copy input
            S1: z = ~x_d;      // invert input
            default: z = 1'b0;
        endcase
    end

endmodule