module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit state variable

always @(posedge clk) begin
    if (!resetn) begin // Reset is active low
        state <= 3'b000; // State A
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            3'b000: begin // State A
                f <= 0;
                g <= 0;
                if (resetn) begin
                    state <= 3'b001; // Move to state B
                end
            end
            3'b001: begin // State B
                f <= 1;
                g <= 0;
                state <= 3'b010; // Move to state C
            end
            3'b010: begin // State C
                f <= 0;
                g <= 0;
                static reg [1:0] x_count; // Counter for x input
                static reg [1:0] x_values; // Store x input values
                if (x) begin
                    x_values <= {1'b1, x_values[1]};
                end else begin
                    x_values <= {1'b0, x_values[1]};
                end
                x_count <= x_count + 1;
                if (x_count == 3 && x_values == 2'b101) begin
                    state <= 3'b011; // Move to state D
                    x_count <= 0;
                    x_values <= 2'b00;
                end
            end
            3'b011: begin // State D
                f <= 0;
                g <= 1;
                static reg [1:0] y_count; // Counter for y input
                y_count <= y_count + 1;
                if (y) begin
                    state <= 3'b100; // Move to state E
                    y_count <= 0;
                end else if (y_count == 2) begin
                    state <= 3'b101; // Move to state F
                    y_count <= 0;
                end
            end
            3'b100: begin // State E
                f <= 0;
                g <= 1;
            end
            3'b101: begin // State F
                f <= 0;
                g <= 0;
            end
            default: begin
                state <= 3'b000; // Reset to state A
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule