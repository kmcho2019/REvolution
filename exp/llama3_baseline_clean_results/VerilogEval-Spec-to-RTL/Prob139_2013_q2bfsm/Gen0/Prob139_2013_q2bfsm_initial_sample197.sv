module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [1:0] state;
reg [1:0] count_x;
reg [1:0] count_y;
reg f_reg;
reg g_reg;

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // state A
        f_reg <= 0;
        g_reg <= 0;
        count_x <= 0;
        count_y <= 0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (resetn) begin
                    state <= 2'b01; // move to state B
                end
            end
            2'b01: begin // state B
                f_reg <= 1;
                state <= 2'b10; // move to state C
            end
            2'b10: begin // state C
                f_reg <= 0;
                if (x) begin
                    count_x <= count_x + 1;
                end else begin
                    count_x <= 0;
                end
                if (count_x == 3) begin
                    g_reg <= 1;
                    state <= 2'b11; // move to state D
                    count_x <= 0;
                end
            end
            2'b11: begin // state D
                if (y) begin
                    count_y <= 2; // set count_y to a value that will not timeout
                end else begin
                    count_y <= count_y + 1;
                end
                if (count_y == 2 && !y) begin
                    g_reg <= 0;
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule