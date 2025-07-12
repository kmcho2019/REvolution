module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding
reg [1:0] current_state;
reg [1:0] next_state;

// State table (combinational logic)
always @(*) begin
    case(current_state)
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
                next_state = 2'b01; // State B
            end else begin
                next_state = 2'b00; // State A
            end
        2'b10: // State C
            if (r[1]) begin
                next_state = 2'b10; // State C
            end else begin
                next_state = 2'b00; // State A
            end
        2'b11: // State D
            // Since state D is not reachable, we don't need to handle its transitions
            next_state = 2'b00; // State A
        default:
            next_state = 2'b00; // State A
    endcase
end

// State flip-flops (sequential logic)
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= 2'b00; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign g[0] = (current_state == 2'b01); // State B
assign g[1] = (current_state == 2'b10); // State C
assign g[2] = 1'b0; // Since state D is not reachable, g[2] is always 0

endmodule