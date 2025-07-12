module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // Current state: 0 - B, 1 - A
reg [0:0] next_state; // Next state

always @(*) begin
    case(state)
        0: begin // State B
            if (!in) begin
                next_state = 1; // Go to state A
            end else begin
                next_state = 0; // Stay in state B
            end
        end
        1: begin // State A
            if (!in) begin
                next_state = 0; // Go to state B
            end else begin
                next_state = 1; // Stay in state A
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to state B
    end else begin
        state <= next_state;
    end
end

assign out = (state == 0) ? 1 : 0; // Output is 1 in state B, 0 in state A

endmodule