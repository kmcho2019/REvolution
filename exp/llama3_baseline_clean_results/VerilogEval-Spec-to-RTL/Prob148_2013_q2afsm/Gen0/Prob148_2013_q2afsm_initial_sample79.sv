module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment for outputs
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0; // Since state D is not used, g[2] will always be 0

// State table
always @(*) begin
    case(state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // State B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // State C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b00; // Still in State A
            end else begin
                next_state = 2'b00; // Still in State A
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Still in State B
            end else begin
                next_state = 2'b00; // Back to State A
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Still in State C
            end else begin
                next_state = 2'b00; // Back to State A
            end
        end
        default: begin
            next_state = 2'b00; // Default to State A
        end
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

endmodule