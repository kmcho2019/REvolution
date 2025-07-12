module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] x_state;
reg [1:0] y_state;
reg [1:0] x_count;
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        x_state <= 0;
        y_state <= 0;
        x_count <= 0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        // Monitor 'x' sequence
        case (x_state)
            0: begin // IDLE
                if (x) begin
                    x_state <= 1;
                    x_count <= 1;
                end
            end
            1: begin // X_HIGH
                if (!x) begin
                    x_state <= 2;
                    x_count <= 1;
                end else begin
                    x_count <= x_count + 1;
                    if (x_count == 2) begin
                        x_state <= 1;
                    end
                end
            end
            2: begin // X_LOW
                if (x) begin
                    x_state <= 3;
                    x_count <= 1;
                end else begin
                    x_count <= x_count + 1;
                    if (x_count == 2) begin
                        x_state <= 2;
                    end
                end
            end
            3: begin // X_HIGH_AGAIN
                f <= 1;
                x_state <= 4;
            end
            4: begin // RESET_F
                f <= 0;
                x_state <= 0;
                y_state <= 1; // Start monitoring 'y'
            end
        endcase

        // Monitor 'y' and control 'g'
        case (y_state)
            0: begin // IDLE
            end
            1: begin // WAIT_Y
                y_count <= y_count + 1;
                if (y) begin
                    g <= 1;
                    y_state <= 2; // Set 'g' to 1 permanently
                end else if (y_count == 2) begin
                    g <= 0;
                    y_state <= 3; // Set 'g' to 0 permanently
                end
            end
            2: begin // G_HIGH
                g <= 1;
            end
            3: begin // G_LOW
                g <= 0;
            end
        endcase
    end
end

endmodule