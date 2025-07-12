module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state; // Current state
reg [1:0] next_state; // Next state

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            begin
                if (r[0] == 1'b1) begin
                    next_state = 2'b01; // State B
                end else if (r[1] == 1'b1) begin
                    next_state = 2'b10; // State C
                end else if (r[2] == 1'b1) begin
                    next_state = 2'b00; // State A (Note: This is not D as D was not fully specified)
                end else begin
                    next_state = 2'b00; // State A
                end
            end
        2'b01: // State B
            begin
                if (r[0] == 1'b1) begin
                    next_state = 2'b01; // State B
                end else begin
                    next_state = 2'b00; // State A
                end
            end
        2'b10: // State C
            begin
                if (r[1] == 1'b1) begin
                    next_state = 2'b10; // State C
                end else begin
                    next_state = 2'b00; // State A
                end
            end
        default: next_state = 2'b00; // State A (default, also handles state D)
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

// Output logic
assign g[0] = (state == 2'b01); // State B
assign g[1] = (state == 2'b10); // State C
assign g[2] = 1'b0; // State D is not used, so g[2] is always 0

endmodule