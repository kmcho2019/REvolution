module TopModule(input clk, input a, output reg q);
    typedef enum {Q0, Q1} state_t;
    state_t current_state, next_state;

    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            Q0: next_state = a ? Q1 : Q0;
            Q1: next_state = a ? Q0 : Q1;
        endcase
    end

    always @(*) begin
        case (current_state)
            Q0: q = 1'b1;
            Q1: q = 1'b0;
        endcase
    end
endmodule