module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] main_state;
reg [1:0] sub_state;
reg [1:0] x_counter;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        main_state <= 0;
        sub_state <= 0;
        x_counter <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (main_state)
            0: begin // RESET
                main_state <= 1;
                sub_state <= 0;
            end
            1: begin // RUNNING
                case (sub_state)
                    0: begin // INIT
                        f <= 1;
                        sub_state <= 1;
                    end
                    1: begin // X_DETECT
                        case (x_counter)
                            0: begin
                                if (x) begin
                                    x_counter <= 1;
                                end
                            end
                            1: begin
                                if (!x) begin
                                    x_counter <= 2;
                                end else begin
                                    x_counter <= 1;
                                end
                            end
                            2: begin
                                if (x) begin
                                    sub_state <= 2;
                                    x_counter <= 0;
                                    g <= 1;
                                end else begin
                                    x_counter <= 2;
                                end
                            end
                        endcase
                    end
                    2: begin // Y_WAIT
                        if (y) begin
                            g <= 1;
                            y_timer <= 0;
                        end else begin
                            y_timer <= y_timer + 1;
                            if (y_timer == 2) begin
                                g <= 0;
                            end
                        end
                    end
                endcase
            end
        endcase
    end
end

endmodule