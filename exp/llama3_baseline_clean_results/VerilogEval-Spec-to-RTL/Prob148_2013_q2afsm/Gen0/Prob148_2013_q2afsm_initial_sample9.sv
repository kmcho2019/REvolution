module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State encoding: A = 00, B = 01, C = 10, D = 11
reg [1:0] state;
reg [1:0] next_state;

// State flip-flop
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        2'b00: // State A
            begin
                if (r[0]) begin
                    next_state = 2'b01; // Grant to device 0
                end else if (r[1]) begin
                    next_state = 2'b10; // Grant to device 1
                end else if (r[2]) begin
                    next_state = 2'b11; // Grant to device 2
                end else begin
                    next_state = 2'b00; // Stay in state A
                end
            end
        2'b01: // State B
            begin
                if (r[0]) begin
                    next_state = 2'b01; // Continue granting to device 0
                end else begin
                    next_state = 2'b00; // Go back to state A
                end
            end
        2'b10: // State C
            begin
                if (r[1]) begin
                    next_state = 2'b10; // Continue granting to device 1
                end else begin
                    next_state = 2'b00; // Go back to state A
                end
            end
        2'b11: // State D
            begin
                if (r[2]) begin
                    next_state = 2'b11; // Continue granting to device 2
                end else begin
                    next_state = 2'b00; // Go back to state A
                end
            end
        default:
            next_state = 2'b00; // Default to state A
    endcase
end

// Output logic
assign g[0] = (state == 2'b01); // Grant to device 0
assign g[1] = (state == 2'b10); // Grant to device 1
assign g[2] = (state == 2'b11); // Grant to device 2

endmodule