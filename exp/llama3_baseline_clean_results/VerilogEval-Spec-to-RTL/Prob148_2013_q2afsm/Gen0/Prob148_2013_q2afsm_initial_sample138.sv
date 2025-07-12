module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] nextState;

// Output logic
assign g[0] = (state == 2'b01); // g0 is 1 when in state B
assign g[1] = (state == 2'b10); // g1 is 1 when in state C
assign g[2] = 1'b0; // g2 is never 1 in this implementation

// State flip-flops
always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= nextState;
    end
end

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            if (r[0]) begin
                nextState = 2'b01; // Grant to device 0
            end else if (r[1]) begin
                nextState = 2'b10; // Grant to device 1
            end else if (r[2]) begin
                nextState = 2'b11; // Grant to device 2
            end else begin
                nextState = 2'b00; // Stay in state A
            end
        2'b01: // State B
            if (r[0]) begin
                nextState = 2'b01; // Continue grant to device 0
            end else begin
                nextState = 2'b00; // Revert to state A
            end
        2'b10: // State C
            if (r[1]) begin
                nextState = 2'b10; // Continue grant to device 1
            end else begin
                nextState = 2'b00; // Revert to state A
            end
        2'b11: // State D
            // This state is not actually used in this implementation
            // We could remove this case, but it's here for completeness
            nextState = 2'b00; // Revert to state A
        default:
            nextState = 2'b00; // Default to state A
    endcase
end

endmodule