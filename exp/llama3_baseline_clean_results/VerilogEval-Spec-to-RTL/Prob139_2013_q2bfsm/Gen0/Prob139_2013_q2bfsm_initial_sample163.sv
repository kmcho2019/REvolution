module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state; // State machine states
reg [1:0] x_sequence; // To track the x input sequence
reg [1:0] y_counter; // Counter to monitor y input after g is set
reg f_reg, g_reg; // Registers for f and g outputs

// Initialize states and outputs
initial begin
    state = 0; // Initial state
    x_sequence = 0; // Reset x sequence counter
    y_counter = 0; // Reset y counter
    f_reg = 0;
    g_reg = 0;
end

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin // Reset condition
        state = 0;
        x_sequence = 0;
        y_counter = 0;
        f_reg = 0;
        g_reg = 0;
    end else begin
        case (state)
            0: begin // Initial state, waiting for reset de-assertion
                if (resetn) begin
                    state = 1; // Transition to set f=1
                end
            end
            1: begin // Set f=1 for one cycle
                f_reg = 1;
                state = 2; // Move to monitoring x sequence
            end
            2: begin // Monitor x sequence
                if (x) begin
                    x_sequence = (x_sequence << 1) | 1; // Shift and set the current bit
                end else begin
                    x_sequence = (x_sequence << 1); // Shift without setting
                end
                if (x_sequence == 5) begin // Sequence 101 detected
                    state = 3; // Transition to set g=1
                    x_sequence = 0; // Reset x sequence
                end
            end
            3: begin // Set g=1 and monitor y
                g_reg = 1;
                if (y) begin // y is high within two cycles, keep g high
                    state = 4; // Permanent g=1 state
                end else begin
                    y_counter = y_counter + 1; // Increment y counter
                    if (y_counter == 2) begin // y did not become high within two cycles
                        state = 5; // Transition to g=0 permanent state
                    end
                end
            end
            4: begin // Permanent g=1 state
                // Do nothing, g remains high
            end
            5: begin // Permanent g=0 state
                g_reg = 0; // Set g to 0
                // Do nothing, g remains low
            end
            default: state = 0; // Default state
        endcase
        f_reg = 0; // Reset f after one cycle
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule