module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    typedef enum logic [0:0] {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t current_state, next_state;

    // State transition
    always @(posedge clk) begin
        if (reset)
            current_state <= B;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b1;
        endcase
    end

endmodule