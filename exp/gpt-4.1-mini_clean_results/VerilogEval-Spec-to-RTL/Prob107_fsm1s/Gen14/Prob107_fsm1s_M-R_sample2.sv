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

    // Sequential logic: state update and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;  // output for reset state B
        end else begin
            state <= next_state;
            case (next_state)
                B: out <= 1'b1;
                A: out <= 1'b0;
                default: out <= 1'b1;
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

endmodule