module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_prev; // Store previous two values of x
reg [1:0] y_count; // Count the number of clock cycles since g = 1
reg [1:0] state; // Current state of the FSM

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        // Reset state
        f <= 0;
        g <= 0;
        x_prev <= 0;
        y_count <= 0;
        state <= 0; // State A
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // Transition to State B
                    f <= 1;
                end
            end
            1: begin // State B
                f <= 0;
                state <= 2; // Transition to State C
                x_prev <= {x, 1'b0}; // Initialize x_prev
            end
            2: begin // State C
                x_prev <= {x, x_prev[0]};
                if (x_prev == 2'b101) begin
                    state <= 3; // Transition to State D
                    g <= 1;
                    y_count <= 0;
                end
            end
            3: begin // State D
                y_count <= y_count + 1;
                if (y) begin
                    state <= 4; // Transition to State E
                end else if (y_count == 2) begin
                    state <= 5; // Transition to State F
                    g <= 0;
                end
            end
            4: begin // State E
                // Maintain g = 1 permanently
            end
            5: begin // State F
                // Maintain g = 0 permanently
            end
        endcase
    end
end

endmodule