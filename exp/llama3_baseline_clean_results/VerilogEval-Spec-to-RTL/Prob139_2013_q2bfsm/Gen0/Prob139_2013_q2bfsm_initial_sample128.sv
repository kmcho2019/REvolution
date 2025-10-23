module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit variable to represent the current state
reg [1:0] x_count; // counter to monitor the x input sequence
reg [1:0] y_count; // counter to monitor the y input

always @(posedge clk) begin
    if (!resetn) begin // reset is asserted
        state <= 3'b000; // stay in state A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            3'b000: begin // state A
                if (x_count == 2'b11) begin // x sequence 1, 0, 1 detected
                    state <= 3'b001; // transition to state B
                    f <= 1;
                    g <= 0;
                    x_count <= 0;
                    y_count <= 0;
                end else if (x == 1'b1) begin
                    x_count <= x_count + 1'b1;
                end else if (x == 1'b0) begin
                    x_count <= x_count + 1'b0;
                end
            end
            3'b001: begin // state B
                state <= 3'b010; // transition to state C
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
            3'b010: begin // state C
                if (x == 1'b1 && x_count == 2'b00) begin
                    x_count <= x_count + 1'b1;
                end else if (x == 1'b0 && x_count == 2'b01) begin
                    x_count <= x_count + 1'b1;
                end else if (x == 1'b1 && x_count == 2'b10) begin
                    state <= 3'b011; // transition to state D
                    g <= 1;
                    x_count <= 0;
                    y_count <= 0;
                end
            end
            3'b011: begin // state D
                if (y == 1'b1) begin
                    state <= 3'b100; // transition to state E
                    g <= 1;
                end else begin
                    y_count <= y_count + 1'b1;
                    if (y_count == 2'b10) begin
                        state <= 3'b101; // transition to state F
                        g <= 0;
                    end
                end
            end
            3'b100: begin // state E
                g <= 1;
            end
            3'b101: begin // state F
                g <= 0;
            end
            default: begin
                state <= 3'b000; // default state
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
        endcase
    end
end

endmodule