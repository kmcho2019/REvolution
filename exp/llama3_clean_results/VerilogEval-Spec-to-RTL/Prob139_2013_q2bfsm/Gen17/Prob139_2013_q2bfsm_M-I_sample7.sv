module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: Reset, 1: Wait for x sequence, 2: Set f high, 3: Wait for y
reg [1:0] x_seq; // 0: Initial, 1: x=1, 2: x=0, x=1
reg [1:0] y_timeout; // Counts clocks after x sequence is detected

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_seq <= 0;
        y_timeout <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Reset state
                state <= 1; // Move to wait for x sequence state
                f <= 1; // Set f high for one clock cycle
            end
            1: begin // Wait for x sequence
                if (x) begin
                    case (x_seq)
                        0: x_seq <= 1;
                        1: x_seq <= 1;
                        2: x_seq <= 2;
                    endcase
                end else begin
                    case (x_seq)
                        0: x_seq <= 0;
                        1: x_seq <= 0;
                        2: x_seq <= 0;
                    endcase
                end
                if (x_seq == 2 && x) begin
                    state <= 2; // Move to set f high state
                    x_seq <= 0;
                end
            end
            2: begin // Set f high
                state <= 3; // Move to wait for y state
                f <= 0; // Ensure f is low after the first clock cycle
                g <= 1; // Set g high initially
                y_timeout <= 0;
            end
            3: begin // Wait for y
                if (y) begin
                    state <= 3; // Stay in this state, g already set high
                    y_timeout <= 0; // Reset y_timeout
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= 1; // Return to initial state
                    end
                end
            end
        endcase
    end
end

endmodule