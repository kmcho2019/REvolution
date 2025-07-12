module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [2:0] x_counter;
reg [1:0] y_timer;
reg f_reg;
reg g_reg;
reg x_seq_det;
reg y_recvd;

initial begin
    state = 2'b00;
    x_counter = 3'b000;
    y_timer = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
    x_seq_det = 1'b0;
    y_recvd = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = 2'b00;
        x_counter = 3'b000;
        y_timer = 2'b00;
        f_reg = 1'b0;
        g_reg = 1'b0;
        x_seq_det = 1'b0;
        y_recvd = 1'b0;
    end else begin
        case (state)
            2'b00: begin // State A
                if (resetn) begin
                    state = 2'b01; // Transition to State B
                    f_reg = 1'b1;
                end
            end
            2'b01: begin // State B
                state = 2'b10; // Transition to State C
                f_reg = 1'b0;
            end
            2'b10: begin // State C
                if (x) begin
                    x_counter = x_counter + 1'b1;
                end else begin
                    x_counter = 3'b000;
                end
                if (x_counter == 3'b101) begin
                    x_seq_det = 1'b1;
                    state = 2'b11; // Transition to State D
                    g_reg = 1'b1;
                end
            end
            2'b11: begin // State D
                y_timer = y_timer + 1'b1;
                if (y) begin
                    y_recvd = 1'b1;
                    g_reg = 1'b1;
                end else if (y_timer == 2'b10) begin
                    g_reg = 1'b0;
                end
                if (y_recvd) begin
                    state = 2'b11; // Stay in State D
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule