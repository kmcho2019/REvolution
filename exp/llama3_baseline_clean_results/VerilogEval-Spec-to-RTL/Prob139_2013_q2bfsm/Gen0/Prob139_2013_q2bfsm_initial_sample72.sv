module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E, 5: F
reg [1:0] x_count; // counter to monitor x input sequence
reg [1:0] y_count; // counter to check if y becomes 1 within two clock cycles

always @(posedge clk) begin
    if (!resetn) begin // reset
        state <= 0; // initial state A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (resetn) begin
                    state <= 1; // move to state B
                end
            end
            1: begin // state B
                f <= 1;
                state <= 2; // move to state C
            end
            2: begin // state C
                f <= 0;
                if (x == 1 && x_count == 0) begin
                    x_count <= 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= 2;
                end else if (x == 1 && x_count == 2) begin
                    x_count <= 0;
                    state <= 3; // move to state D
                end else begin
                    x_count <= 0;
                end
            end
            3: begin // state D
                g <= 1;
                y_count <= y_count + 1;
                if (y == 1 || y_count == 2) begin
                    if (y == 1) begin
                        state <= 4; // move to state E
                    end else begin
                        state <= 5; // move to state F
                    end
                end
            end
            4: begin // state E
                g <= 1;
            end
            5: begin // state F
                g <= 0;
            end
        endcase
    end
end

endmodule