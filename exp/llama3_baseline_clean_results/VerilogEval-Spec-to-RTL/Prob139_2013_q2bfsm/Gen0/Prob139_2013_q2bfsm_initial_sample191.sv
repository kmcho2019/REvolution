module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State variable, using 3 bits for 6 states

always @(posedge clk) begin
    if (!resetn) begin // Reset condition
        state <= 0; // State A
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // State A
                state <= 1; // Move to State B
                f <= 0;
                g <= 0;
            end
            1: begin // State B
                state <= 2; // Move to State C
                f <= 1;
                g <= 0;
            end
            2: begin // State C
                if (x) begin // Start of sequence 1, 0, 1
                    state <= 3; // Move to a sub-state of C to track sequence
                    f <= 0;
                    g <= 0;
                end else begin
                    state <= 2; // Stay in C
                    f <= 0;
                    g <= 0;
                end
            end
            3: begin // Sub-state of C, waiting for 0 after 1
                if (!x) begin
                    state <= 4; // Move to next sub-state
                    f <= 0;
                    g <= 0;
                end else begin
                    state <= 2; // Reset sequence tracking
                    f <= 0;
                    g <= 0;
                end
            end
            4: begin // Sub-state of C, waiting for 1 after 0
                if (x) begin
                    state <= 5; // Move to State D
                    f <= 0;
                    g <= 0;
                end else begin
                    state <= 2; // Reset sequence tracking
                    f <= 0;
                    g <= 0;
                end
            end
            5: begin // State D
                state <= 6; // Wait for y
                f <= 0;
                g <= 1;
            end
            6: begin // Waiting for y
                if (y) begin
                    state <= 7; // Move to State E
                    f <= 0;
                    g <= 1;
                end else if (state == 6) begin // First cycle without y
                    state <= 6; // Wait another cycle
                    f <= 0;
                    g <= 1;
                end else begin // Second cycle without y, move to State F
                    state <= 8;
                    f <= 0;
                    g <= 0;
                end
            end
            7: begin // State E
                state <= 7; // Stay in E
                f <= 0;
                g <= 1;
            end
            8: begin // State F
                state <= 8; // Stay in F
                f <= 0;
                g <= 0;
            end
            default: begin
                state <= 0; // Default to State A
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule