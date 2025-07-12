module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D,
    STATE_E,
    STATE_F
} state, next_state;

reg [1:0] x_sequence;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;

initial begin
    state = STATE_A;
    x_sequence = 2'b00;
    y_counter = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_sequence <= 2'b00;
        y_counter <= 2'b00;
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        case (state)
            STATE_A: begin
                if (resetn) begin
                    state <= STATE_B;
                    f_reg <= 1'b1;
                end
            end
            STATE_B: begin
                state <= STATE_C;
                f_reg <= 1'b0;
            end
            STATE_C: begin
                if (x) begin
                    x_sequence <= {x_sequence[0], 1'b1};
                end else begin
                    x_sequence <= {x_sequence[0], 1'b0};
                end
                if (x_sequence == 2'b11) begin
                    x_sequence <= 2'b00;
                    state <= STATE_D;
                    g_reg <= 1'b1;
                end
            end
            STATE_D: begin
                if (y) begin
                    state <= STATE_E;
                end else if (y_counter == 2'b10) begin
                    state <= STATE_F;
                    g_reg <= 1'b0;
                end else begin
                    y_counter <= y_counter + 1'b1;
                end
            end
            STATE_E: begin
                // Stay in STATE_E
            end
            STATE_F: begin
                // Stay in STATE_F
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule