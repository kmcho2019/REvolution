module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 0: State A, 1: State B, 2: State C, 3: State D, 4: State E, 5: State F
reg [1:0] count_x; // counter for x sequence
reg [1:0] count_y; // counter for y sequence
reg f_reg, g_reg;

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        state <= 0;
        f_reg <= 0;
        g_reg <= 0;
        count_x <= 0;
        count_y <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1;
                    f_reg <= 1;
                end
            end
            1: begin // State B
                state <= 2;
                f_reg <= 0;
            end
            2: begin // State C
                if (x) begin
                    count_x[0] <= 1;
                end else begin
                    count_x[0] <= 0;
                end
                if (count_x[0] && ~count_x[1] && x) begin
                    count_x[1] <= 1;
                end else if (~count_x[0] && count_x[1] && ~x) begin
                    count_x[1] <= 0;
                    count_x[0] <= 0;
                end
                if (count_x[0] && count_x[1] && x) begin
                    state <= 3;
                    g_reg <= 1;
                end
            end
            3: begin // State D
                if (!y) begin
                    count_y <= count_y + 1;
                end
                if (y || count_y == 2) begin
                    if (y) begin
                        state <= 4;
                    end else begin
                        state <= 5;
                        g_reg <= 0;
                    end
                end
            end
            4: begin // State E
                g_reg <= 1;
            end
            5: begin // State F
                g_reg <= 0;
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule