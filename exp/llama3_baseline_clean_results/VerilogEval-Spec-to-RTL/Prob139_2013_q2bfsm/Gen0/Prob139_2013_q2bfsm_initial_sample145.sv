module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State A = 3'b000, State B = 3'b001, State C = 3'b010, State D = 3'b011, State E = 3'b100, State F = 3'b101
reg [1:0] x_count; // Counter for x input sequence
reg [1:0] y_count; // Counter for y input timeout

always @(posedge clk) begin
    if (!resetn) begin // Reset condition
        state <= 3'b000; // Stay in State A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (x == 1 && x_count == 0) begin
                    x_count <= x_count + 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= x_count + 1;
                end else if (x == 1 && x_count == 2) begin
                    state <= 3'b001; // Move to State B
                    x_count <= 0;
                end
                f <= 0;
                g <= 0;
            end
            3'b001: begin // State B
                f <= 1;
                state <= 3'b010; // Move to State C
            end
            3'b010: begin // State C
                f <= 0;
                if (x == 1 && x_count == 0) begin
                    x_count <= x_count + 1;
                end else if (x == 0 && x_count == 1) begin
                    x_count <= x_count + 1;
                end else if (x == 1 && x_count == 2) begin
                    state <= 3'b011; // Move to State D
                    x_count <= 0;
                end
                g <= 0;
            end
            3'b011: begin // State D
                g <= 1;
                if (y == 1) begin
                    state <= 3'b100; // Move to State E
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= 3'b101; // Move to State F
                    end
                end
            end
            3'b100: begin // State E
                g <= 1;
            end
            3'b101: begin // State F
                g <= 0;
            end
        endcase
    end
end

endmodule