module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg [1:0] state; // 0 - A, 1 - B
reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        0: begin // State A
            if (in) begin
                next_state = 0; // Stay in A if in is 1
            end else begin
                next_state = 1; // Go to B if in is 0
            end
        end
        1: begin // State B
            if (in) begin
                next_state = 1; // Stay in B if in is 1
            end else begin
                next_state = 0; // Go to A if in is 0
            end
        end
        default: next_state = 1; // Default to state B
    endcase
end

always @(*) begin
    case(state)
        0: out = 0; // Output 0 in state A
        1: out = 1; // Output 1 in state B
        default: out = 1; // Default to 1
    endcase
end

endmodule