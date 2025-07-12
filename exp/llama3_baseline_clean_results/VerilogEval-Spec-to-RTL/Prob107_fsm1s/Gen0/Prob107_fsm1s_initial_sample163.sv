module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // 0: A, 1: B
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // State A
            if (~in) begin
                next_state = 1; // A -> B
            end else begin
                next_state = 0; // A -> A
            end
        end
        1: begin // State B
            if (~in) begin
                next_state = 0; // B -> A
            end else begin
                next_state = 1; // B -> B
            end
        end
        default: next_state = 1; // Default state: B
    endcase
end

always @(*) begin
    case (state)
        0: out = 0; // State A: out = 0
        1: out = 1; // State B: out = 1
        default: out = 1; // Default: out = 1
    endcase
end

endmodule