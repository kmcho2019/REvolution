module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: Reset, 1: Wait for x sequence, 2: Set f high and wait for y
reg [1:0] x_cnt; // Counts the 'x' sequence
reg [1:0] y_cnt; // Counts clocks after 'x' sequence is detected

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_cnt <= 0;
        y_cnt <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Reset state
                state <= 1; // Move to wait for x sequence state
                f <= 1; // Set f high for one clock cycle
            end
            1: begin // Wait for x sequence
                case (x_cnt)
                    0: begin
                        if (x) begin
                            x_cnt <= 1;
                        end
                    end
                    1: begin
                        if (!x) begin
                            x_cnt <= 2;
                        end else begin
                            x_cnt <= 1;
                        end
                    end
                    2: begin
                        if (x) begin
                            state <= 2; // Move to set f high and wait for y state
                            x_cnt <= 0;
                            y_cnt <= 0;
                            g <= 1; // Set g high initially
                        end else begin
                            x_cnt <= 2;
                        end
                    end
                endcase
            end
            2: begin // Set f high and wait for y
                if (y) begin
                    state <= 2; // Stay in this state, g already set high
                end else begin
                    y_cnt <= y_cnt + 1;
                    if (y_cnt == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= 1; // Return to initial state
                    end
                end
                f <= 0; // Ensure f is low after the first clock cycle
            end
        endcase
    end
end

endmodule