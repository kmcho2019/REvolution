module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state;
reg [1:0] x_counter;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= 0; // State A
        f_reg <= 0;
        g_reg <= 0;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1; // State B
                    f_reg <= 1;
                    g_reg <= 0;
                end
            end
            1: begin // State B
                state <= 2; // State C
                f_reg <= 0;
            end
            2: begin // State C
                if (x_counter == 3'b101) begin
                    state <= 3; // State D
                    g_reg <= 1;
                    x_counter <= 0;
                    y_counter <= 0;
                end else begin
                    x_counter <= {x_counter[1:0], x};
                end
            end
            3: begin // State D
                if (y) begin
                    state <= 4; // State E
                    y_counter <= 0;
                end else if (y_counter == 2'b11) begin
                    state <= 5; // State F
                    g_reg <= 0;
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            4, 5: begin // States E and F
                // Do nothing
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule