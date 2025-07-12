module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [1:0] x_count;
reg [1:0] y_count;
reg f_reg;
reg g_reg;

initial begin
    state = 2'b00;
    x_count = 2'b00;
    y_count = 2'b00;
    f_reg = 1'b0;
    g_reg = 1'b0;
end

always @ (posedge clk) begin
    if (!resetn) begin
        state = 2'b00;
        x_count = 2'b00;
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
                    x_count = x_count + 1'b1;
                end else begin
                    x_count = 2'b00;
                end
                if (x_count == 2'b11) begin
                    state = 2'b11; // Transition to State D
                    g_reg = 1'b1;
                end
            end
            2'b11: begin // State D
                y_count = y_count + 1'b1;
                if (y) begin
                    state = 2'b100; // Transition to State E
                    y_count = 2'b00;
                end else if (y_count == 2'b10) begin
                    state = 2'b101; // Transition to State F
                    g_reg = 1'b0;
                end
            end
            2'b100: begin // State E
                // Stay in State E
            end
            2'b101: begin // State F
                // Stay in State F
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule