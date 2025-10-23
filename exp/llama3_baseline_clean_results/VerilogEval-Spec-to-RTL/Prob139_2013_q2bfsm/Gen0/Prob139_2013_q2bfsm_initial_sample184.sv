module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101
reg [1:0] x_count; // counter for x input sequence
reg [1:0] y_count; // counter for y input sequence

always @(posedge clk) begin
    if (~resetn) begin // reset
        state <= 3'b000; // state A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            3'b000: begin // state A
                state <= 3'b001; // move to state B
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
            3'b001: begin // state B
                state <= 3'b010; // move to state C
                f <= 1;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
            3'b010: begin // state C
                if (x_count == 2'b00 && x == 1) begin
                    x_count <= 2'b01;
                end else if (x_count == 2'b01 && x == 0) begin
                    x_count <= 2'b10;
                end else if (x_count == 2'b10 && x == 1) begin
                    state <= 3'b011; // move to state D
                    x_count <= 0;
                end else begin
                    x_count <= 0;
                end
                f <= 0;
                g <= 0;
            end
            3'b011: begin // state D
                state <= 3'b100; // move to state E
                g <= 1;
                y_count <= 0;
                f <= 0;
            end
            3'b100: begin // state E
                if (y == 1) begin
                    state <= 3'b100; // stay in state E
                end else if (y_count == 2'b10) begin
                    state <= 3'b101; // move to state F
                end else begin
                    y_count <= y_count + 1;
                end
                f <= 0;
                g <= 1;
            end
            3'b101: begin // state F
                f <= 0;
                g <= 0;
            end
            default: begin
                state <= 3'b000; // reset to state A
                f <= 0;
                g <= 0;
                x_count <= 0;
                y_count <= 0;
            end
        endcase
    end
end

endmodule