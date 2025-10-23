module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state; // current state
reg [1:0] next_state; // next state

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // State A ( device 2 has the lowest priority, so it will not change state)
            end else begin
                next_state = 2'b00; // State A (no requests)
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        default: // State D (not used)
            next_state = 2'b00; // State A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // reset to State A
    end else begin
        state <= next_state;
    end
end

// Outputs
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // device 2 will not receive a grant

endmodule