module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

    // State encoding using parameters for slight flexibility
    parameter B = 1'b0;
    parameter A = 1'b1;

    reg state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state and output logic combined
    always @(*) begin
        case (state)
            B: begin
                next_state = (in == 1'b0) ? A : B;
                out = 1'b1;  // output = 1 in state B
            end
            A: begin
                next_state = (in == 1'b0) ? B : A;
                out = 1'b0;  // output = 0 in state A
            end
            default: begin
                next_state = B;
                out = 1'b1;
            end
        endcase
    end

endmodule