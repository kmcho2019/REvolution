module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // State register
reg [2:0] x_seq; // Sequence detector for x
reg [1:0] y_cnt; // Counter for monitoring y

// Initial state
initial state = 2'b00; // State A
initial f = 1'b0;
initial g = 1'b0;
initial x_seq = 3'b000;
initial y_cnt = 2'b00;

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin // Reset condition
        state <= 2'b00; // Stay in reset state
        f <= 1'b0;
        g <= 1'b0;
        x_seq <= 3'b000;
        y_cnt <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // State A: Reset state
                if (resetn) begin
                    state <= 2'b01; // Transition to state B
                end
                f <= 1'b0;
                g <= 1'b0;
            end
            2'b01: begin // State B: Set f = 1 for one clock cycle
                f <= 1'b1;
                state <= 2'b10; // Transition to state C
            end
            2'b10: begin // State C: Monitor x for sequence 1, 0, 1
                x_seq <= {x, x_seq[2:1]}; // Update sequence detector
                if (x_seq == 3'b101) begin // Sequence detected
                    state <= 2'b11; // Transition to state D
                    g <= 1'b1; // Set g = 1
                end
                f <= 1'b0; // Reset f
            end
            2'b11: begin // State D: Monitor y while g = 1
                if (y) begin // y is 1 within two cycles
                    state <= 2'b11; // Stay in state D
                    y_cnt <= 2'b00; // Reset counter
                end else begin
                    y_cnt <= y_cnt + 1; // Increment counter
                    if (y_cnt == 2'b10) begin // y did not become 1 within two cycles
                        state <= 2'b01; // Transition back to state B (not state E as per correction, to maintain g = 0 after two cycles)
                        g <= 1'b0; // Set g = 0
                    end
                end
            end
            default: begin
                state <= 2'b00; // Default to reset state
            end
        endcase
    end
end

endmodule