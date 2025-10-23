module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

reg [2:0] state; // 3 bits to represent 6 states (0 to 5)
reg [1:0] x_count; // counter for x input sequence
reg [1:0] y_count; // counter for y input
reg f_reg;
reg g_reg;

always @(posedge clk) begin
    if (~resetn) begin // reset
        state <= 0; // state A
        x_count <= 0;
        y_count <= 0;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (~resetn) begin // stay in reset state
                    state <= 0;
                end else begin // move to state B
                    state <= 1;
                    f_reg <= 1; // set f to 1 for one clock cycle
                end
            end
            1: begin // state B
                state <= 2; // move to state C
                f_reg <= 0; // clear f
            end
            2: begin // state C
                if (x) begin // x = 1, increment x_count
                    x_count <= x_count + 1;
                end else begin // x = 0, reset x_count if not in sequence
                    if (x_count == 1) begin
                        x_count <= 2; // x = 0 after x = 1
                    end else begin
                        x_count <= 0; // reset x_count
                    end
                end
                if (x_count == 3) begin // x sequence 1, 0, 1 detected
                    state <= 3; // move to state D
                    g_reg <= 1; // set g to 1
                    x_count <= 0; // reset x_count
                end
            end
            3: begin // state D
                if (y) begin // y = 1, move to state E
                    state <= 4;
                end else begin // y = 0, increment y_count
                    y_count <= y_count + 1;
                    if (y_count == 2) begin // y not detected within 2 clock cycles
                        state <= 5; // move to state F
                        g_reg <= 0; // clear g
                    end
                end
            end
            4: begin // state E
                // stay in state E, g = 1
            end
            5: begin // state F
                // stay in state F, g = 0
            end
            default: begin
                state <= 0; // default to state A
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule