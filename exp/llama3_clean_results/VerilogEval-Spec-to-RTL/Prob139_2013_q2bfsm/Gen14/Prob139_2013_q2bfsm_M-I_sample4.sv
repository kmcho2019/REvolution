module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E, 5: F, 6: G, 7: H
reg [1:0] y_timer; // Timer for y
reg [1:0] x_sequence; // Tracker for x sequence

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0;
        y_timer <= 0;
        x_sequence <= 0;
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
                    x_sequence <= 1; // x = 1
                    state <= 3;
                end
            end
            3: begin // D
                if (!x && x_sequence == 1) begin
                    x_sequence <= 2; // x = 0
                    state <= 4;
                end else if (x) begin
                    x_sequence <= 1; // x = 1
                end else begin
                    x_sequence <= 0; // x = 0
                    state <= 2;
                end
            end
            4: begin // E
                if (x && x_sequence == 2) begin
                    state <= 5;
                    g <= 1;
                end else if (x) begin
                    x_sequence <= 1; // x = 1
                    state <= 2;
                end else begin
                    x_sequence <= 0; // x = 0
                    state <= 2;
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