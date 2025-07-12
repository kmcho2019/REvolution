module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg current_state; // 1'b0 for A, 1'b1 for B
reg next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b1; // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        1'b0: begin // State A
            if (in == 1'b1) begin
                next_state = 1'b0; // Stay in A
            end else begin
                next_state = 1'b1; // Go to B
            end
        end
        1'b1: begin // State B
            if (in == 1'b0) begin
                next_state = 1'b0; // Go to A
            end else begin
                next_state = 1'b1; // Stay in B
            end
        end
        default: next_state = 1'b1; // Default to state B
    endcase
end

always @(*) begin
    case(current_state)
        1'b0: out = 1'b0; // State A, output 0
        1'b1: out = 1'b1; // State B, output 1
        default: out = 1'b1; // Default to output 1 (State B)
    endcase
end

endmodule