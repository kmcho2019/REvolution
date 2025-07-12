module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_counter;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_counter <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // RESET
                if (resetn) begin
                    state <= 1;
                    f <= 1;
                end
            end
            1: begin // SET_F
                state <= 2;
                f <= 0;
            end
            2: begin // CHECK_X
                if (x_counter == 0 && x) begin
                    x_counter <= 1;
                end else if (x_counter == 1 && !x) begin
                    x_counter <= 2;
                end else if (x_counter == 2 && x) begin
                    x_counter <= 0;
                    g <= 1;
                    state <= 3;
                    y_timer <= 2;
                end else begin
                    x_counter <= 0;
                end
            end
            3: begin // CHECK_Y
                if (y_timer > 0) begin
                    if (y) begin
                        y_timer <= 0;
                    end else begin
                        y_timer <= y_timer - 1;
                        if (y_timer == 0) begin
                            g <= 0;
                            state <= 2;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule