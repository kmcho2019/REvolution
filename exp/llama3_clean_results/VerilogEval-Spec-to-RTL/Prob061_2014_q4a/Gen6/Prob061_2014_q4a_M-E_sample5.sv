module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        1'b0: begin // Idle state
            if (L) next_state = 1'b1; // Load state
            else if (E) next_state = 1'b2; // Shift state
            else next_state = 1'b0; // Stay in idle
        end
        1'b1: begin // Load state
            next_state = 1'b0; // After loading, go back to idle
        end
        1'b2: begin // Shift state
            next_state = 1'b0; // After shifting, go back to idle
        end
        default: next_state = 1'b0;
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;
    case(current_state)
        1'b0: begin // Idle state, do nothing
            Q <= Q;
        end
        1'b1: begin // Load state
            Q <= R;
        end
        1'b2: begin // Shift state
            Q <= w;
        end
        default: Q <= Q;
    endcase
end

initial begin
    current_state = 1'b0;
end

endmodule