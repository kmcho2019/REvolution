module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding using an enumerated type
    typedef enum logic {
        B = 1'b0,
        A = 1'b1
    } state_t;

    state_t state, next_state;
    reg next_out;

    // Combinational logic for next state and next output
    always @(*) begin
        case(state)
            B: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
                next_out = 1'b1; // output for state B
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;
                else
                    next_state = A;
                next_out = 1'b0; // output for state A
            end
            default: begin
                next_state = B;
                next_out = 1'b1;
            end
        endcase
    end

    // Sequential logic for state and output with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;
        end else begin
            state <= next_state;
            out <= next_out;
        end
    end

endmodule