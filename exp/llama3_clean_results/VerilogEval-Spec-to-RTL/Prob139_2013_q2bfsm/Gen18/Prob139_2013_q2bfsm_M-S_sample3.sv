module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: Reset, 1: Reset Release, 2: Detect X Sequence, 3: Wait for Y
reg [1:0] x_seq; // Counts the sequence of x
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
                state <= 1; // Move to reset release state
            end
            1: begin // Reset release state
                state <= 2; // Move to detect x sequence state
                f <= 1; // Set f high for one clock cycle
            end
            2: begin // Detect x sequence
                f <= 0; // Reset f
                if (x_seq == 0) begin
                    if (x) begin
                        x_seq <= 1;
                    end
                end else if (x_seq == 1) begin
                    if (!x) begin
                        x_seq <= 2;
                    end else begin
                        x_seq <= 1;
                    end
                end else if (x_seq == 2) begin
                    if (x) begin
                        state <= 3; // Move to wait for y state
                        g <= 1; // Set g high initially
                        y_timeout <= 0;
                        x_seq <= 0;
                    end else begin
                        x_seq <= 0; // Reset x_seq
                    end
                end
            end
            3: begin // Wait for y
                if (y) begin
                    // Stay in this state, g already set high
                    y_timeout <= 0; // Reset y_timeout
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= 2; // Return to detect x sequence state
                    end
                end
            end
        endcase
    end
end

endmodule