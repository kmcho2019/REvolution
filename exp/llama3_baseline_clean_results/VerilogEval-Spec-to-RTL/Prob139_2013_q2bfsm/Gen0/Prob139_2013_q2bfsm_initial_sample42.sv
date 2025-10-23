module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [1:0] state; // 0: state A, 1: state B, 2: state C, 3: state D, 4: state E0 (g=0), 5: state E1 (g=1)
reg [1:0] x_seq; // sequence of x
reg [1:0] y_count; // count of clock cycles in state D
reg f_reg;
reg g_reg;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0;
        x_seq <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (resetn) begin
                    state <= 1;
                    f_reg <= 1;
                end else begin
                    state <= 0;
                end
            end
            1: begin // state B
                state <= 2;
                f_reg <= 0;
            end
            2: begin // state C
                if (x_seq == 3'b101) begin
                    state <= 3;
                    g_reg <= 1;
                    y_count <= 0;
                    x_seq <= 0;
                end else begin
                    x_seq <= {x_seq[0], x};
                end
            end
            3: begin // state D
                y_count <= y_count + 1;
                if (y) begin
                    state <= 5; // state E1
                end else if (y_count == 2) begin
                    state <= 4; // state E0
                end
            end
            4: begin // state E0
                g_reg <= 0;
            end
            5: begin // state E1
                // maintain g = 1
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule