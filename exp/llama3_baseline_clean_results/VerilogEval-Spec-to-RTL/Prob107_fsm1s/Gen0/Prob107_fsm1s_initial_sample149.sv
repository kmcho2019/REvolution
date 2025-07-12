module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

typedef enum {B, A} state_type;
state_type current_state, next_state;

always @(*) begin
    case(current_state)
        B: begin
            if (in == 0) next_state = A;
            else next_state = B;
        end
        A: begin
            if (in == 0) next_state = B;
            else next_state = A;
        end
        default: next_state = B;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        B: out = 1;
        A: out = 0;
        default: out = 1;
    endcase
end

endmodule