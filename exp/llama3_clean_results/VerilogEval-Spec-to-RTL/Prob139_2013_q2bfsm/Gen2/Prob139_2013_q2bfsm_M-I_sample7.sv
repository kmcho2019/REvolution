module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state;
reg [1:0] x_prev;
reg y_count;
reg f_reg;
reg g_reg;

initial begin
    state = 3'b000;
    x_prev = 2'b00;
    y_count = 1'b0;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = 3'b000;
        x_prev = 2'b00;
        y_count = 1'b0;
        f_reg = 1'b0;
        g_reg = 1'b0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (resetn) begin
                    state = 3'b001; // Transition to State B
                    f_reg = 1'b1;
                end
            end
            3'b001: begin // State B
                state = 3'b010; // Transition to State C
                f_reg = 1'b0;
            end
            3'b010: begin // State C
                x_prev = {x_prev[0], x};
                if (x_prev == 2'b01) begin
                    state = 3'b011; // Transition to State D
                end else if (x_prev == 2'b10) begin
                    state = 3'b010; // Stay in State C
                end else if (x_prev == 2'b11) begin
                    state = 3'b100; // Transition to State E
                end
            end
            3'b011: begin // State D
                if (x) begin
                    state = 3'b100; // Transition to State E
                    g_reg = 1'b1;
                end else begin
                    state = 3'b010; // Transition back to State C
                end
            end
            3'b100: begin // State E
                y_count = y_count + 1'b1;
                if (y || y_count == 2'b10) begin
                    state = 3'b101; // Transition to State F
                    if (y) begin
                        g_reg = 1'b1;
                    end else begin
                        g_reg = 1'b0;
                    end
                end
            end
            3'b101: begin // State F
                // Stay in State F
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule