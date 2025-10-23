module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding
    typedef enum logic [1:0] {
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3
    } state_t;

    state_t current_state, next_state;

    // Next state and output logic with case statement (combinational)
    always @(*) begin
        case (current_state)
            A: begin
                next_state = (in) ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = (in) ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = (in) ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = (in) ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

endmodule