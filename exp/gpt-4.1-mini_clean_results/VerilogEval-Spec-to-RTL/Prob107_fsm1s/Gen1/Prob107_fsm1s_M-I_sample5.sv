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

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= B;
        else
            state <= next_state;
    end

    // Next state and output logic combined to reduce redundant logic
    always @(*) begin
        case(state)
            B: begin
                out = 1'b1;
                next_state = (in == 1'b0) ? A : B;
            end
            A: begin
                out = 1'b0;
                next_state = (in == 1'b0) ? B : A;
            end
            default: begin
                out = 1'b1;
                next_state = B;
            end
        endcase
    end

endmodule