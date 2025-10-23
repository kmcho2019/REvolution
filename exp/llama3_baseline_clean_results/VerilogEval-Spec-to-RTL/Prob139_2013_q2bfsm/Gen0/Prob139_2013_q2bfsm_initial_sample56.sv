module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // State A
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            0: begin // State A
                state <= 1; // State B
                f <= 1;
                g <= 0;
            end
            1: begin // State B
                state <= 2; // State C
                f <= 0;
                g <= 0;
            end
            2: begin // State C
                if (x == 1) begin
                    state <= 3; // State C1
                end
            end
            3: begin // State C1
                if (x == 0) begin
                    state <= 4; // State C2
                end else begin
                    state <= 2; // State C
                end
            end
            4: begin // State C2
                if (x == 1) begin
                    state <= 5; // State D
                    g <= 1;
                end else begin
                    state <= 2; // State C
                end
            end
            5: begin // State D
                if (y == 1) begin
                    state <= 6; // State E
                end else if (g == 1 && state == 5) begin
                    state <= 7; // State F
                    g <= 0;
                end
            end
            6: begin // State E
                g <= 1;
            end
            7: begin // State F
                g <= 0;
            end
            default: begin
                state <= 0; // State A
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule