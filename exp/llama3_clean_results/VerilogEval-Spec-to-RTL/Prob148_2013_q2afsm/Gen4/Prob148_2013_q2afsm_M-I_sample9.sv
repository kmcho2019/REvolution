module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

// State codes
reg [1:0] current_state;
reg [1:0] next_state;

// Clock enable for power reduction
reg clk_enable;

// State flip-flops with clock gating
always @(posedge clk) begin
    if (~resetn) begin
        current_state <= 2'b00;  // Reset to state A
    end else if (clk_enable) begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        2'b00:  // State A
            if (r[0]) begin
                next_state = 2'b01;  // Go to state B
                clk_enable = 1'b1;
            end else if (r[1]) begin
                next_state = 2'b10;  // Go to state C
                clk_enable = 1'b1;
            end else if (r[2]) begin
                next_state = 2'b11;  // Go to state D
                clk_enable = 1'b1;
            end else begin
                next_state = 2'b00;  // Stay in state A
                clk_enable = 1'b0;
            end
        2'b01:  // State B
            if (r[0]) begin
                next_state = 2'b01;  // Stay in state B
                clk_enable = 1'b0;
            end else begin
                next_state = 2'b00;  // Go back to state A
                clk_enable = 1'b1;
            end
        2'b10:  // State C
            if (r[1]) begin
                next_state = 2'b10;  // Stay in state C
                clk_enable = 1'b0;
            end else begin
                next_state = 2'b00;  // Go back to state A
                clk_enable = 1'b1;
            end
        2'b11:  // State D
            if (r[2]) begin
                next_state = 2'b11;  // Stay in state D
                clk_enable = 1'b0;
            end else begin
                next_state = 2'b00;  // Go back to state A
                clk_enable = 1'b1;
            end
        default:
            next_state = 2'b00;  // Default to state A
            clk_enable = 1'b1;
    endcase
end

// Assign output signals g[0], g[1], and g[2] based on the current state
assign g[0] = (current_state == 2'b01);
assign g[1] = (current_state == 2'b10);
assign g[2] = (current_state == 2'b11);

endmodule