module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding
    localparam B = 1'b0, A = 1'b1;

    reg state, next_state;

    // Next state logic and output logic (Moore FSM)
    always @(*) begin
        case (state)
            B: begin
                out = 1'b1;
                next_state = (in == 1'b0) ? A : B;
            end
            A: begin
                out = 1'b0;
                next_state = (in == 1'b0) ? B : A;
            end
            default: begin
                out = 1'b1;      // Default output to B state output
                next_state = B;  // Default state on undefined
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

endmodule