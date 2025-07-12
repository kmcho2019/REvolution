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

    // Combinational next state logic as a function of current state and input
    always @(*) begin
        case(state)
            B: next_state = (in == 1'b0) ? A : B;
            A: next_state = (in == 1'b0) ? B : A;
            default: next_state = B;
        endcase
    end

    // Synchronous process updating state and output together
    always @(posedge clk) begin
        if (reset) begin
            state <= B;
            out <= 1'b1;   // output for reset state B
        end else begin
            state <= next_state;
            // output based on Moore state machine definition
            out <= (next_state == B) ? 1'b1 : 1'b0;
        end
    end

endmodule