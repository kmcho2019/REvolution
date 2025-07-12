module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

enum logic [2:0] {
    IDLE,
    SET_F,
    MONITOR_X,
    SET_G,
    MONITOR_Y
} state, next_state;

reg [1:0] x_sequence;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;
reg [1:0] x_seq_counter;

initial begin
    state = IDLE;
    x_sequence = 2'b00;
    y_counter = 2'b00;
    x_seq_counter = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = IDLE;
        x_sequence = 2'b00;
        y_counter = 2'b00;
        x_seq_counter = 2'b00;
        f_reg = 1'b0;
        g_reg = 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (!resetn) begin
                    state = IDLE;
                end else begin
                    state = SET_F;
                    f_reg = 1'b1;
                end
            end
            SET_F: begin
                state = MONITOR_X;
                f_reg = 1'b0;
                x_seq_counter = 2'b00;
            end
            MONITOR_X: begin
                if (x_seq_counter == 2'b00 && x) begin
                    x_seq_counter = x_seq_counter + 1'b1;
                end else if (x_seq_counter == 2'b01 && !x) begin
                    x_seq_counter = x_seq_counter + 1'b1;
                end else if (x_seq_counter == 2'b10 && x) begin
                    state = SET_G;
                    g_reg = 1'b1;
                end else begin
                    x_seq_counter = 2'b00;
                end
            end
            SET_G: begin
                state = MONITOR_Y;
            end
            MONITOR_Y: begin
                if (y_counter < 2) begin
                    y_counter = y_counter + 1'b1;
                end
                if (y) begin
                    // g_reg is already set to 1'b1, do nothing
                end else if (y_counter == 2) begin
                    g_reg = 1'b0;
                    state = IDLE;
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule