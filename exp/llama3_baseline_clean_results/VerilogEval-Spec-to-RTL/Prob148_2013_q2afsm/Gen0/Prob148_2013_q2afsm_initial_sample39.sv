module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State table
always @(state or r) begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // State D
            end else begin
                next_state = 2'b00; // Stay in State A
            end
        2'b01: // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in State B
            end else begin
                next_state = 2'b00; // Go to State A
            end
        2'b10: // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in State C
            end else begin
                next_state = 2'b00; // Go to State A
            end
        default: // State D
            next_state = 2'b00; // Go to State A
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to State A
    end else begin
        state <= next_state;
    end
end

// Output logic
assign g[0] = (state == 2'b01); // g0 is 1 in State B
assign g[1] = (state == 2'b10); // g1 is 1 in State C
assign g[2] = 1'b0; // g2 is always 0, as there is no State D

endmodule