module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state;
reg [2:0] counter;
reg y_flag;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        counter <= 0;
        y_flag <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (resetn) begin
                    state <= 1;
                    f <= 1;
                end
            end
            1: begin // X_SEQUENCE
                if (x) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                end
                if (counter == 3) begin
                    state <= 2;
                    g <= 1;
                    counter <= 0;
                end
                f <= 0;
            end
            2: begin // Y_WAIT
                if (y) begin
                    y_flag <= 1;
                end
                if (counter == 2 && !y_flag) begin
                    g <= 0;
                    state <= 1;
                end
                if (y_flag) begin
                    state <= 3;
                end
                counter <= counter + 1;
            end
            3: begin // HOLD_G_HIGH
                g <= 1;
            end
        endcase
    end
end

endmodule