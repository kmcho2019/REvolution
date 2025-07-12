module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D
reg [1:0] x_sequence;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // State A
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            0: begin // State A
                state <= 1; // Move to State B
                f <= 1;
            end
            1: begin // State B
                state <= 2; // Move to State C
                f <= 0;
                x_sequence <= 0;
            end
            2: begin // State C
                if (x_sequence == 0) begin
                    if (x) begin
                        x_sequence <= 1;
                    end
                end else if (x_sequence == 1) begin
                    if (!x) begin
                        x_sequence <= 2;
                    end else begin
                        x_sequence <= 0;
                    end
                end else if (x_sequence == 2) begin
                    if (x) begin
                        state <= 3; // Move to State D
                        g <= 1;
                        y_timer <= 1;
                        x_sequence <= 0;
                    end else begin
                        x_sequence <= 0;
                    end
                end
            end
            3: begin // State D
                if (y) begin
                    state <= 3; // Stay in State D
                    y_timer <= 0;
                end else begin
                    y_timer <= y_timer + 1;
                    if (y_timer > 2) begin
                        state <= 3; // Stay in State D but set g to 0
                        g <= 0;
                        y_timer <= 0;
                    end
                end
            end
        endcase
    end
end

endmodule