module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    typedef enum {STATE_B, STATE_A} state_t;
    state_t state;

    // Single always block for state transitions
    always @(posedge clk) begin
        if (reset)
            state <= STATE_B;
        else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
                default: state <= STATE_B;
            endcase
        end
    end

    // Output remains simple continuous assignment
    assign out = (state == STATE_B);

endmodule