module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [1:0] x_shift;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        x_shift <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // RESET
                state <= 1;
                x_shift <= 0;
                y_timer <= 0;
            end
            1: begin // INIT
                f <= 1;
                state <= 2;
                x_shift <= 0;
            end
            2: begin // X_DETECT
                x_shift <= {x_shift[0], x};
                if (x_shift == 3'b101) begin
                    state <= 3;
                    g <= 1;
                end
            end
            3: begin // Y_WAIT
                if (y) begin
                    g <= 1;
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer == 2) begin
                        g <= 0;
                    end
                end
                f <= 0; // Ensure f is 0 in all states except INIT
            end
        endcase
    end
end

endmodule