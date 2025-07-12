module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

typedef enum logic [1:0] {State0, State1} state_t;
state_t current_state, next_state;

always @(posedge clock) begin
    case (current_state)
        State0: begin
            if (a == 1) begin
                next_state = State1;
                p = a;
                q = 0;
            end else begin
                next_state = State0;
                p = 0;
                q = 0;
            end
        end
        State1: begin
            if (a == 1) begin
                next_state = State1;
                p = a;
                q = 1;
            end else begin
                next_state = State1;
                p = 0;
                q = 1;
            end
        end
        default: begin
            next_state = State0;
            p = 0;
            q = 0;
        end
    endcase
end

always @(negedge clock) begin
    if (current_state == State1 && a == 0) begin
        next_state = State0;
        q = 0;
    end
end

always @(posedge clock) begin
    current_state = next_state;
end

initial begin
    current_state = State0;
    next_state = State0;
    p = 0;
    q = 0;
end

endmodule