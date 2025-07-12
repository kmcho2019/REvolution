module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

typedef enum logic {S0 = 1'b0, S1 = 1'b1} state_t;
state_t current_state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    next_state = current_state;
    rise = 1'b0;
    down = 1'b0;
    
    case (current_state)
        S0: begin
            if (a) begin
                next_state = S1;
                rise = 1'b1;
            end
        end
        S1: begin
            if (!a) begin
                next_state = S0;
                down = 1'b1;
            end
        end
    endcase
end

endmodule