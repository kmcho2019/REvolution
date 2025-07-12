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

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state and output logic: Moore FSM
    always @(*) begin
        case (state)
            B: begin
                next_state = (in == 1'b0) ? A : B;
                out = 1'b1;
            end
            A: begin
                next_state = (in == 1'b0) ? B : A;
                out = 1'b0;
            end
            default: begin
                next_state = B;
                out = 1'b1;
            end
        endcase
    end

endmodule