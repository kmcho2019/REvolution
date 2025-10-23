module TopModule(clk, resetn, x, y, f, g);
    input clk, resetn, x, y;
    output f, g;

    reg [2:0] state; // 0: State A, 1: State B, 2: State C, 3: State D, 4: State E, 5: State F
    reg [1:0] count_x; // counter for state C
    reg [1:0] count_y; // counter for state D
    reg [1:0] seq_x; // sequence detector for x

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            state <= 0;
            f <= 0;
            g <= 0;
            count_x <= 0;
            count_y <= 0;
            seq_x <= 0;
        end else begin
            case(state)
                0: begin // State A
                    if (resetn) begin
                        state <= 1;
                    end else begin
                        state <= 0;
                    end
                end
                1: begin // State B
                    f <= 1;
                    state <= 2;
                end
                2: begin // State C
                    f <= 0;
                    if (x) begin
                        seq_x <= {seq_x[0], 1};
                    end else begin
                        seq_x <= {seq_x[0], 0};
                    end
                    count_x <= count_x + 1;
                    if (count_x == 3 && seq_x == 2'b101) begin
                        state <= 3;
                        count_x <= 0;
                        seq_x <= 0;
                    end
                end
                3: begin // State D
                    g <= 1;
                    count_y <= count_y + 1;
                    if (y) begin
                        state <= 4;
                        count_y <= 0;
                    end else if (count_y == 2) begin
                        state <= 5;
                        count_y <= 0;
                    end
                end
                4: begin // State E
                    g <= 1;
                end
                5: begin // State F
                    g <= 0;
                end
            endcase
        end
    end
endmodule