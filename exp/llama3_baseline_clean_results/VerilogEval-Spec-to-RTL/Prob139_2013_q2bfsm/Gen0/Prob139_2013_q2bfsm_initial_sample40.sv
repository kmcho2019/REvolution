module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // State A = 3'b000, State B = 3'b001, State C = 3'b010, State D = 3'b011, State E = 3'b100, State F = 3'b101
reg [1:0] x_count; // Counter for x sequence
reg [1:0] y_count; // Counter for y clock cycles

always @(posedge clk) begin
    if (~resetn) begin // Reset condition
        state <= 3'b000; // State A
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (resetn) begin
                    state <= 3'b001; // State B
                end
            end
            3'b001: begin // State B
                f <= 1;
                state <= 3'b010; // State C
            end
            3'b010: begin // State C
                f <= 0;
                if (x) begin
                    x_count <= x_count + 1;
                    if (x_count == 3) begin
                        state <= 3'b011; // State D
                        x_count <= 0;
                        g <= 1;
                    end
                end else begin
                    x_count <= 0;
                end
            end
            3'b011: begin // State D
                if (y) begin
                    state <= 3'b100; // State E
                    y_count <= 0;
                end else begin
                    y_count <= y_count + 1;
                    if (y_count == 2) begin
                        state <= 3'b101; // State F
                        g <= 0;
                    end
                end
            end
            3'b100, 3'b101: begin // States E and F
                // No transition, stay in the same state
            end
        endcase
    end
end

endmodule