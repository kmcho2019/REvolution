module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [1:0] state; // State A = 2'b00, State B = 2'b01, State C = 2'b10, State D = 2'b11
reg [1:0] x_sequence; // to track the x input sequence
reg [1:0] y_counter; // to count the clock cycles in State D

always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00; // State A
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (resetn) begin
                    state <= 2'b01; // State B
                end
            end
            2'b01: begin // State B
                f <= 1;
                state <= 2'b10; // State C
            end
            2'b10: begin // State C
                f <= 0;
                if (x_sequence == 2'b101) begin
                    state <= 2'b11; // State D
                    g <= 1;
                    x_sequence <= 0;
                end else begin
                    if (x) begin
                        x_sequence <= {1, x_sequence[0]};
                    end else begin
                        x_sequence <= {0, x_sequence[0]};
                    end
                end
            end
            2'b11: begin // State D
                if (y || y_counter == 2) begin
                    if (y) begin
                        state <= 2'b11; // remains in State D
                    end else begin
                        state <= 2'b00; // goes back to State A (g = 0)
                        g <= 0;
                    end
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            default: state <= 2'b00; // State A
        endcase
    end
end

endmodule