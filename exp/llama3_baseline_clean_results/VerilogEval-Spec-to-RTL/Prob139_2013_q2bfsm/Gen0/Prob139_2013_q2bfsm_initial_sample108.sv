module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [2:0] state; // 0: A, 1: B, 2: C, 3: D, 4: E
reg f_reg;
reg g_reg;
reg [1:0] counter;
reg seq_detected;

always @(posedge clk) begin
    if (~resetn) begin
        state <= 0;
        f_reg <= 0;
        g_reg <= 0;
        counter <= 0;
        seq_detected <= 0;
    end else begin
        case (state)
            0: begin // State A
                if (resetn) begin
                    state <= 1;
                    f_reg <= 1;
                end
            end
            1: begin // State B
                f_reg <= 0;
                state <= 2;
                seq_detected <= 0;
            end
            2: begin // State C
                if (seq_detected) begin
                    state <= 3;
                    g_reg <= 1;
                    counter <= 0;
                end else if (x == 1) begin
                    seq_detected <= 1;
                end else if (x == 0 && seq_detected == 1) begin
                    seq_detected <= 2;
                end else if (x == 1 && seq_detected == 2) begin
                    seq_detected <= 3;
                end else if (seq_detected == 3) begin
                    seq_detected <= 0;
                end
            end
            3: begin // State D
                counter <= counter + 1;
                if (y == 1 || counter == 2) begin
                    if (y == 1) begin
                        state <= 4;
                    end else begin
                        state <= 2;
                        g_reg <= 0;
                    end
                end
            end
            4: begin // State E
                g_reg <= 1;
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule