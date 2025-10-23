module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [1:0] x_seq;
reg [1:0] y_count;
reg f_reg;
reg g_reg;

initial begin
    state = 2'b00;
    x_seq = 2'b00;
    y_count = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = 2'b00;
        x_seq = 2'b00;
        y_count = 2'b00;
        f_reg = 1'b0;
        g_reg = 1'b0;
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
                    x_seq = 2'b01;
                end else if (x_seq == 2'b01) begin
                    x_seq = 2'b10;
                end else if (x_seq == 2'b10 && x) begin
                    state = 2'b11; // Transition to State D
                    x_seq = 2'b00;
                end else begin
                    x_seq = 2'b00;
                end
            end
            2'b11: begin // State D
                g_reg = 1'b1; // Set g to 1
                y_count = 2'b01; // Initialize y count
                state = 2'b10; // Transition back to State C
            end
        endcase

        if (g_reg) begin
            if (y) begin
                y_count = 2'b00; // Reset y count if y is 1
            end else if (y_count == 2'b10) begin
                g_reg = 1'b0; // Set g to 0 if y is not 1 within 2 cycles
            end else begin
                y_count = y_count + 1'b1; // Increment y count
            end
        end
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule