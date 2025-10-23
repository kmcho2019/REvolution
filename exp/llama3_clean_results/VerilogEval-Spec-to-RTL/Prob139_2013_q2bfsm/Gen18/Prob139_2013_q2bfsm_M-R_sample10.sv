module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: Reset, 1: Set f high, 2: Wait for x sequence, 3: Wait for y
reg [1:0] x_seq; // Tracks sequence of x
reg [1:0] y_timeout; // Counts clocks after x sequence is detected

// Output assignments
assign f = (state == 1);

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_seq <= 0;
        y_timeout <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // Reset state
                state <= 1; // Move to set f high state
            end
            1: begin // Set f high
                state <= 2; // Move to wait for x sequence
            end
            2: begin // Wait for x sequence
                if (x) begin
                    x_seq <= {x_seq[0], 1'b1};
                end else begin
                    x_seq <= {x_seq[0], 1'b0};
                end
                if (x_seq == 2'b101) begin
                    state <= 3; // Move to wait for y
                    g <= 1;
                    y_timeout <= 0;
                end else if (x_seq != 0) begin
                    x_seq <= 0; // Reset x_seq if not the desired sequence
                end
            end
            3: begin // Wait for y
                if (y) begin
                    y_timeout <= 0; // Reset y_timeout
                end else begin
                    y_timeout <= y_timeout + 1;
                    if (y_timeout == 2) begin
                        g <= 0; // Set g low if y doesn't occur within 2 clocks
                        state <= 2; // Return to wait for x sequence
                    end
                end
            end
        endcase
    end
end

endmodule