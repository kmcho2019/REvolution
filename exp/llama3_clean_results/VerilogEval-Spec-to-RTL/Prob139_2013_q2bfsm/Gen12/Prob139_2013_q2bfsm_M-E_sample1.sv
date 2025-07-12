module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] y_timer;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        y_timer <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // A
                state <= 1;
                f <= 1;
            end
            1: begin // B
                state <= 2;
                f <= 0;
            end
            2: begin // C
                if (x) begin
                    state <= 3;
                end
            end
            3: begin // D
                if (!x) begin
                    state <= 4;
                end
            end
            4: begin // E
                if (x) begin
                    state <= 5;
                    g <= 1;
                end
            end
            5: begin // F
                if (y) begin
                    state <= 6;
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer == 2) begin
                        state <= 7;
                    end
                end
            end
            6: begin // G
                g <= 1;
            end
            7: begin // H
                g <= 0;
            end
        endcase
    end
end

endmodule