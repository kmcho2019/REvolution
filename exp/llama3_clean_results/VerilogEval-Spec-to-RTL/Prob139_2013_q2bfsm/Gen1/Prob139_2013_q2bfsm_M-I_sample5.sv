module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit state register
reg [1:0] counter; // 2-bit counter for state D
reg [2:0] x_sequence; // 3-bit sequence detector for x

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0; // state A
        f <= 0;
        g <= 0;
        counter <= 0;
        x_sequence <= 0;
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
                if (x_sequence == 5) begin // x_sequence = 101
                    state <= 3; // transition to state D
                    g <= 1;
                    counter <= 1;
                    x_sequence <= 0;
                end else begin
                    state <= 2; // stay in state C
                    x_sequence <= {x_sequence[1:0], x};
                end
            end
            3: begin // state D
                counter <= counter + 1;
                if (y || counter == 2) begin
                    if (y) begin
                        state <= 4; // transition to state E
                    end else begin
                        state <= 5; // transition to state F
                    end
                    counter <= 0;
                end else begin
                    state <= 3; // stay in state D
                end
            end
            4: begin // state E
                state <= 4; // stay in state E
                g <= 1;
            end
            5: begin // state F
                state <= 5; // stay in state F
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