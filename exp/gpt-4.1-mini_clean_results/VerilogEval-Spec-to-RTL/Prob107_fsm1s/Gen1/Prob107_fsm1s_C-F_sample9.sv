module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Combined next state and output logic for Moore FSM
    always @(*) begin
        case (state)
            B: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                out = 1'b1;   // default output for safe fallback
                next_state = B; // default next state
            end
        endcase
    end

endmodule