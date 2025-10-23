module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [1:0] state; // state A, state B, state C, state D, state E
reg [1:0] count_x; // counter for x sequence
reg [1:0] count_y; // counter for y sequence
reg f_reg;
reg g_reg;

always @ (posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // state A
        f_reg <= 0;
        g_reg <= 0;
        count_x <= 2'b00;
        count_y <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // state A
                if (resetn) begin
                    state <= 2'b01; // state B
                    f_reg <= 1;
                end else begin
                    state <= 2'b00; // state A
                end
            end
            2'b01: begin // state B
                state <= 2'b10; // state C
                f_reg <= 0;
            end
            2'b10: begin // state C
                if (x) begin
                    count_x <= count_x + 1;
                    if (count_x == 2'b01) begin
                        state <= 2'b11; // state D
                    end
                end else if (count_x == 2'b01) begin
                    count_x <= 2'b00;
                end else if (count_x == 2'b10) begin
                    count_x <= 2'b00;
                end
            end
            2'b11: begin // state D
                if (~x) begin
                    count_x <= count_x + 1;
                    if (count_x == 2'b10) begin
                        state <= 2'b11; // state D
                        g_reg <= 1;
                    end
                end else if (count_x == 2'b10) begin
                    count_x <= 2'b00;
                end
            end
            default: begin // state E
                if (y) begin
                    state <= 2'b11; // state E
                end else if (count_y == 2'b10) begin
                    state <= 2'b10; // state C
                    g_reg <= 0;
                end else begin
                    count_y <= count_y + 1;
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule