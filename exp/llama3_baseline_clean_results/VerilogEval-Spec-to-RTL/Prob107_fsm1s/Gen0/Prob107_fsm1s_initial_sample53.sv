module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

typedef enum logic {B, A} state_type;
state_type current_state, next_state;

always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        B: begin
            if (~in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (~in) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        default: begin
            next_state = B;
        end
    endcase
end

always_comb begin
    case (current_state)
        B: out = 1;
        A: out = 0;
        default: out = 1;
    endcase
end

endmodule