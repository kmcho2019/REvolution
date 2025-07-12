module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0]) begin
                next_state = 2'b01; // State B
            end else if (r[1]) begin
                next_state = 2'b10; // State C
            end else if (r[2]) begin
                next_state = 2'b11; // State D
            end else begin
                next_state = 2'b00; // State A
            end
        2'b01: // State B
            if (r[0]) begin
                next_state = 2'b01; // Stay in State B
            end else begin
                next_state = 2'b00; // Back to State A
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // Stay in State C
            end else begin
                next_state = 2'b00; // Back to State A
            end
        2'b11: // State D
            if (r[2]) begin
                next_state = 2'b11; // Stay in State D
            end else begin
                next_state = 2'b00; // Back to State A
            end
        default: next_state = 2'b00;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Outputs
assign g[0] = (state == 2'b01); // State B grants device 0
assign g[1] = (state == 2'b10); // State C grants device 1
assign g[2] = (state == 2'b11); // State D grants device 2

endmodule