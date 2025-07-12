module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding
    localparam B = 1'b0;
    localparam A = 1'b1;

    reg state, next_state;

    // Next-state and output logic: Moore FSM with registered output
    always @(*) begin
        case (state)
            B: begin
                out = 1'b1;
                if (~in)
                    next_state = A;
                else
                    next_state = B;
            end
            A: begin
                out = 1'b0;
                if (~in)
                    next_state = B;
                else
                    next_state = A;
            end
            default: begin
                // Safe default to state B and output 1
                out = 1'b1;
                next_state = B;
            end
        endcase
    end

    // State update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

endmodule