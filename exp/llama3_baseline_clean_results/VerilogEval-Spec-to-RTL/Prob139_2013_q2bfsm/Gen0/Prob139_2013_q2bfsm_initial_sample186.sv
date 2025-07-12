module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    reg [2:0] state;
    parameter A = 3'b000, SET_F = 3'b001, MONITOR_X = 3'b010, MONITOR_Y = 3'b011, G_PERMANENT = 3'b100, G_PERMANENT_RESET = 3'b101;
    reg [1:0] x_counter, y_counter;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            x_counter <= 0;
            y_counter <= 0;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    state <= SET_F;
                end
                SET_F: begin
                    f <= 1;
                    state <= MONITOR_X;
                end
                MONITOR_X: begin
                    f <= 0;
                    if (x) begin
                        x_counter <= x_counter + 1;
                    end else begin
                        x_counter <= 0;
                    end
                    if (x_counter == 3) begin
                        state <= MONITOR_Y;
                        g <= 1;
                        y_counter <= 0;
                    end
                end
                MONITOR_Y: begin
                    if (y) begin
                        state <= G_PERMANENT;
                    end else begin
                        y_counter <= y_counter + 1;
                        if (y_counter == 2) begin
                            state <= G_PERMANENT_RESET;
                        end
                    end
                end
                G_PERMANENT: begin
                    //do nothing
                end
                G_PERMANENT_RESET: begin
                    g <= 0;
                    //do nothing
                end
                default: state <= A;
            endcase
        end
    end

endmodule