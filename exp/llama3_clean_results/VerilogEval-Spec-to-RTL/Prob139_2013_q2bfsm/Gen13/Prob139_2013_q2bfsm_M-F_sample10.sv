module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output reg f,
    output reg g
);

// Named states for better readability
enum logic [2:0] { 
    RESET, 
    PULSE_F, 
    DETECT_SEQUENCE, 
    DETECT_Y, 
    G_HIGH 
} state, next_state;

reg [1:0] x_count; // count for x sequence
reg [1:0] y_count; // count for y detection

always @ (posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            RESET: begin
                if (resetn) begin
                    state <= PULSE_F;
                end
            end
            PULSE_F: begin
                f <= 1;
                state <= DETECT_SEQUENCE;
            end
            DETECT_SEQUENCE: begin
                case (x_count)
                    0: begin
                        if (x == 1) begin
                            x_count <= 1;
                        end
                    end
                    1: begin
                        if (x == 0) begin
                            x_count <= 2;
                        end else begin
                            x_count <= 0;
                        end
                    end
                    2: begin
                        if (x == 1) begin
                            state <= DETECT_Y;
                            x_count <= 0;
                        end else begin
                            x_count <= 0;
                        end
                    end
                endcase
            end
            DETECT_Y: begin
                y_count <= y_count + 1;
                if (y) begin
                    state <= G_HIGH;
                    g <= 1;
                end else if (y_count == 2) begin // y not detected within 2 cycles
                    g <= 0;
                    state <= DETECT_SEQUENCE;
                end
            end
            G_HIGH: begin
                g <= 1;
            end
        endcase
        if (state != PULSE_F) begin
            f <= 0;
        end
    end
end

endmodule