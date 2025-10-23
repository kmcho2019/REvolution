module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment for output signals g
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        2'b00: begin // State A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Go to state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // Go to state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // Go to state D
            end else begin
                next_state = 2'b00; // Stay in state A
            end
        end
        2'b01: begin // State B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // Stay in state B
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        end
        2'b10: begin // State C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // Stay in state C
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        end
        2'b11: begin // State D
            if (r[2] == 1'b1) begin
                next_state = 2'b11; // Stay in state D
            end else begin
                next_state = 2'b00; // Go back to state A
            end
        end
        default: begin
            next_state = 2'b00; // Default to state A
        end
    endcase
end

endmodule