module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding
    typedef enum reg [1:0] {A=2'd0, B=2'd1, C=2'd2, D=2'd3} state_t;
    state_t state, next_state;

    // Next state and output logic
    always @(*) begin
        case (state)
            A: begin
                out = 1'b0;
                next_state = in ? B : A;
            end
            B: begin
                out = 1'b0;
                next_state = in ? B : C;
            end
            C: begin
                out = 1'b0;
                next_state = in ? D : A;
            end
            D: begin
                out = 1'b1;
                next_state = in ? B : C;
            end
            default: begin
                out = 1'b0;
                next_state = A;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

endmodule