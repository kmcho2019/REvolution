module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    typedef enum logic [1:0] {A=2'd0, B=2'd1, C=2'd2, D=2'd3} state_t;
    state_t state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            state <= next_state;
            case (next_state)
                D: out <= 1'b1;
                default: out <= 1'b0;
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

endmodule