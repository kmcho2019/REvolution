module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [1:0] state; // State variable (A=2'b00, B=2'b01, C=2'b10, D=2'b11)
reg [1:0] count_x; // Counter for x sequence
reg [1:0] count_y; // Counter for y monitoring
reg last_x; // Last value of x
reg last_f; // Last value of f

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= 2'b00; // Reset to state A
        f <= 0;
        g <= 0;
        count_x <= 2'b00;
        count_y <= 2'b00;
        last_x <= 0;
        last_f <= 0;
    end else begin
        case(state)
            2'b00: begin // State A
                if (resetn) begin
                    state <= 2'b01; // Move to state B
                    last_f <= 0;
                end
                f <= 0;
                g <= 0;
            end
            2'b01: begin // State B
                state <= 2'b10; // Move to state C
                f <= 1;
                g <= 0;
                last_f <= 1;
            end
            2'b10: begin // State C
                if (x == 1 && last_x == 0) begin
                    count_x <= count_x + 1;
                end else if (x == 0 && last_x == 1 && count_x == 1) begin
                    count_x <= count_x + 1;
                end else if (x == 1 && last_x == 0 && count_x == 2) begin
                    state <= 2'b11; // Move to state D
                    count_x <= 2'b00;
                end else begin
                    count_x <= 2'b00;
                end
                last_x <= x;
                f <= 0;
                g <= 0;
            end
            2'b11: begin // State D
                g <= 1;
                count_y <= count_y + 1;
                if (y == 1 || count_y > 2) begin
                    if (y == 1) begin
                        state <= 2'b11; // Stay in state D if y = 1
                    end else begin
                        state <= 2'b00; // Move to state A if y doesn't become 1 within two cycles
                    end
                    count_y <= 2'b00;
                end
                f <= 0;
            end
            default: begin
                state <= 2'b00;
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule