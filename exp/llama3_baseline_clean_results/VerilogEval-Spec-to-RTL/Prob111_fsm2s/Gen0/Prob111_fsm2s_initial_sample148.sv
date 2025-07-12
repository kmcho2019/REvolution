module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [1:0] state; // 0: OFF, 1: ON
reg [1:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        0: begin // OFF state
            if (j) begin
                next_state = 1; // Transition to ON state
            end else begin
                next_state = 0; // Stay in OFF state
            end
        end
        1: begin // ON state
            if (k) begin
                next_state = 0; // Transition to OFF state
            end else begin
                next_state = 1; // Stay in ON state
            end
        end
        default: next_state = 0; // Default to OFF state
    endcase
end

always @(*) begin
    case (state)
        0: out = 0; // Output is 0 in OFF state
        1: out = 1; // Output is 1 in ON state
        default: out = 0; // Default output is 0
    endcase
end

endmodule