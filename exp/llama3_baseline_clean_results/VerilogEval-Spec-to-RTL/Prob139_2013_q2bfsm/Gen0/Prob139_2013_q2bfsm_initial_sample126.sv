module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state;
reg [1:0] x_counter;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;

parameter STATE_A = 3'b000;
parameter STATE_B = 3'b001;
parameter STATE_C = 3'b010;
parameter STATE_D = 3'b011;
parameter STATE_E = 3'b100;
parameter STATE_F = 3'b101;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f_reg <= 0;
        g_reg <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            STATE_A: begin
                if (resetn) begin
                    state <= STATE_B;
                end
            end
            STATE_B: begin
                f_reg <= 1;
                state <= STATE_C;
            end
            STATE_C: begin
                f_reg <= 0;
                if (x_counter == 2'b11 && x == 1) begin
                    state <= STATE_D;
                    x_counter <= 0;
                end else if (x == 1'b1 && x_counter == 2'b00) begin
                    x_counter <= 2'b01;
                end else if (x == 1'b0 && x_counter == 2'b01) begin
                    x_counter <= 2'b10;
                end else if (x == 1'b1 && x_counter == 2'b10) begin
                    x_counter <= 2'b11;
                end else begin
                    x_counter <= 0;
                end
            end
            STATE_D: begin
                g_reg <= 1;
                state <= STATE_D;
                if (y == 1'b1) begin
                    state <= STATE_E;
                    y_counter <= 0;
                end else if (y_counter < 2) begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        state <= STATE_F;
                        g_reg <= 0;
                    end
                end
            end
            STATE_E: begin
                g_reg <= 1;
            end
            STATE_F: begin
                g_reg <= 0;
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule