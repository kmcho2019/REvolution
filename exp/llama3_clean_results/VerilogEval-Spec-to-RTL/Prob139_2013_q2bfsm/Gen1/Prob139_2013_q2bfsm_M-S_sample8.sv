module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit state register
reg x_prev; // previous value of x
reg x_prev_prev; // value of x two clock cycles ago
reg y_seen; // flag to indicate whether y has been seen within two clock cycles
reg counter; // flag to count two clock cycles

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0; // state A
        f <= 0;
        g <= 0;
        x_prev <= 0;
        x_prev_prev <= 0;
        y_seen <= 0;
        counter <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (resetn) begin
                    state <= 1; // transition to state B
                    f <= 1;
                    g <= 0;
                end else begin
                    state <= 0; // stay in state A
                    f <= 0;
                    g <= 0;
                end
            end
            1: begin // state B
                state <= 2; // transition to state C
                f <= 0;
                g <= 0;
            end
            2: begin // state C
                x_prev_prev <= x_prev;
                x_prev <= x;
                if (x_prev_prev == 1 && x_prev == 0 && x == 1) begin
                    state <= 3; // transition to state D
                    g <= 1;
                    y_seen <= 0;
                    counter <= 1;
                end else begin
                    state <= 2; // stay in state C
                end
            end
            3: begin // state D
                counter <= counter + 1;
                if (y) begin
                    y_seen <= 1;
                end
                if (counter == 2) begin
                    if (y_seen) begin
                        state <= 3; // stay in state D
                    end else begin
                        state <= 4; // transition to state F
                        g <= 0;
                    end
                    counter <= 0;
                end
            end
            4: begin // state F
                state <= 4; // stay in state F
                g <= 0;
            end
            default: begin
                state <= 0; // default to state A
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule