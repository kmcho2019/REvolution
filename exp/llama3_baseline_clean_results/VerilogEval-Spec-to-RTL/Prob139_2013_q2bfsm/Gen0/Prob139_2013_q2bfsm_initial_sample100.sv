module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // State A: 3'b000, State B: 3'b001, State C: 3'b010, State D: 3'b011, State E: 3'b100, State F: 3'b101
reg [1:0] x_count; // Counter for x sequence
reg [1:0] y_count; // Counter for y
reg f_reg;
reg g_reg;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 3'b000; // State A
        x_count <= 2'b00;
        y_count <= 2'b00;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            3'b000: begin // State A
                if (resetn) begin
                    state <= 3'b001; // State B
                end
                f_reg <= 0;
                g_reg <= 0;
            end
            3'b001: begin // State B
                state <= 3'b010; // State C
                f_reg <= 1;
                g_reg <= 0;
            end
            3'b010: begin // State C
                if (x) begin
                    if (x_count == 2'b00) begin
                        x_count <= 2'b01;
                    end else if (x_count == 2'b01 && ~x) begin
                        x_count <= 2'b10;
                    end else if (x_count == 2'b10 && x) begin
                        state <= 3'b011; // State D
                        x_count <= 2'b00;
                    end
                end else if (x_count == 2'b01) begin
                    x_count <= 2'b10;
                end else if (x_count == 2'b10) begin
                    x_count <= 2'b00;
                end
                f_reg <= 0;
                g_reg <= 0;
            end
            3'b011: begin // State D
                state <= 3'b100; // State E
                g_reg <= 1;
                y_count <= 2'b01;
            end
            3'b100: begin // State E
                if (~y && y_count < 2'b10) begin
                    y_count <= y_count + 1;
                end else if (~y && y_count == 2'b10) begin
                    state <= 3'b101; // State F
                    g_reg <= 0;
                end
                f_reg <= 0;
            end
            3'b101: begin // State F
                f_reg <= 0;
                g_reg <= 0;
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule