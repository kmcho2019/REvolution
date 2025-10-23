module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E, 5: F
reg [1:0] x_counter; // counter for x sequence
reg [1:0] y_counter; // counter for y sequence
reg f_reg;
reg g_reg;
reg x_seq_detected;

always @(posedge clk) begin
    if (!resetn) begin
        state <= 0; // state A
        f_reg <= 0;
        g_reg <= 0;
        x_counter <= 0;
        y_counter <= 0;
        x_seq_detected <= 0;
    end else begin
        case (state)
            0: begin // state A
                if (resetn) begin
                    state <= 1; // state B
                end
                f_reg <= 0;
                g_reg <= 0;
            end
            1: begin // state B
                f_reg <= 1;
                state <= 2; // state C
            end
            2: begin // state C
                f_reg <= 0;
                case (x_counter)
                    0: begin
                        if (x) begin
                            x_counter <= 1;
                        end
                    end
                    1: begin
                        if (!x) begin
                            x_counter <= 2;
                        end else begin
                            x_counter <= 1;
                        end
                    end
                    2: begin
                        if (x) begin
                            x_seq_detected <= 1;
                            state <= 3; // state D
                        end else begin
                            x_counter <= 1;
                        end
                    end
                endcase
            end
            3: begin // state D
                if (x_seq_detected) begin
                    g_reg <= 1;
                    y_counter <= 1;
                    state <= 4; // state E
                end
            end
            4: begin // state E
                if (y) begin
                    state <= 4; // stay in state E
                    y_counter <= 0;
                end else begin
                    y_counter <= y_counter + 1;
                    if (y_counter == 2) begin
                        state <= 5; // state F
                    end
                end
            end
            5: begin // state F
                g_reg <= 0;
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule