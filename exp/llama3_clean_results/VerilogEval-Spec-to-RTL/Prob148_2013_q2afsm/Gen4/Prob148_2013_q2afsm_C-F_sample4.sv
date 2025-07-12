module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0]) next_state = 2'b01; // Transition to State B
            else if (r[1]) next_state = 2'b10; // Transition to State C
            else if (r[2]) next_state = 2'b11; // Transition to State D
            else next_state = 2'b00; // Stay in State A
        end
        2'b01: begin // State B
            if (r[0]) next_state = 2'b01; // Stay in State B
            else next_state = 2'b00; // Back to State A
        end
        2'b10: begin // State C
            if (r[1]) next_state = 2'b10; // Stay in State C
            else next_state = 2'b00; // Back to State A
        end
        2'b11: begin // State D
            if (r[2]) next_state = 2'b11; // Stay in State D
            else next_state = 2'b00; // Back to State A
        end
        default: next_state = 2'b00; // Default to State A
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to State A
    else state <= next_state;
end

assign g[0] = (state == 2'b01); // State B grants device 0
assign g[1] = (state == 2'b10); // State C grants device 1
assign g[2] = (state == 2'b11); // State D grants device 2

endmodule