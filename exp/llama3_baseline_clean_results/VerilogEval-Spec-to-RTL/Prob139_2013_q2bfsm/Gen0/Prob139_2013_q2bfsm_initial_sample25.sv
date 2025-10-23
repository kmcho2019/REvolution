module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0 - State A, 1 - State B, 2 - State C, 3 - State D, 4 - State E, 5 - State F
reg [1:0] x_counter; // Counter for x sequence
reg [1:0] y_counter; // Counter for y check

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // Reset to State A
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // Move to State B when resetn is high
                end
            end
            1: begin // State B
                f <= 1; // Set f to 1
                state <= 2; // Move to State C
            end
            2: begin // State C
                if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0; // Reset counter if x is not 1
                end
                if (x_counter == 3'b100) begin // Check for sequence 1, 0, 1
                    state <= 3; // Move to State D
                    x_counter <= 0; // Reset counter
                end
            end
            3: begin // State D
                g <= 1; // Set g to 1
                if (y) begin
                    state <= 4; // Move to State E if y is high
                    y_counter <= 0; // Reset counter
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        state <= 5; // Move to State F if y is not high within 2 cycles
                    end
                end
            end
            4, 5: begin // States E and F
                // Maintain g value, no state change
                f <= 0; // Ensure f is 0 in these states
            end
            default: begin
                state <= 0; // Reset to State A for any other condition
            end
        endcase
    end
end

always @(*) begin
    case (state)
        1: f = 1;
        default: f = 0;
    endcase
end

always @(*) begin
    case (state)
        4: g = 1;
        5: g = 0;
        default: g = 0;
    endcase
end

endmodule