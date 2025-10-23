module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    reg [2:0] state; // state A = 3'b000, state B = 3'b001, state C = 3'b010, state D = 3'b011, state E = 3'b100, state F = 3'b101
    reg [1:0] x_count; // counter for x sequence
    reg [1:0] y_count; // counter for y
    reg f_reg;
    reg g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= 3'b000; // reset state
            x_count <= 2'b00;
            y_count <= 2'b00;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            case (state)
                3'b000: begin // state A
                    if (resetn) begin
                        state <= 3'b001; // move to state B
                    end
                end
                3'b001: begin // state B
                    f_reg <= 1; // set f to 1
                    state <= 3'b010; // move to state C
                end
                3'b010: begin // state C
                    if (x_count == 2'b00 && x) begin
                        x_count <= x_count + 1;
                    end else if (x_count == 2'b01 && !x) begin
                        x_count <= x_count + 1;
                    end else if (x_count == 2'b10 && x) begin
                        state <= 3'b011; // move to state D
                        x_count <= 2'b00;
                    end else begin
                        x_count <= 2'b00;
                    end
                end
                3'b011: begin // state D
                    g_reg <= 1; // set g to 1
                    state <= 3'b100; // move to state E
                    y_count <= 2'b00;
                end
                3'b100: begin // state E
                    if (y) begin
                        state <= 3'b100; // stay in state E
                        y_count <= 2'b00;
                    end else if (y_count == 2'b10) begin
                        state <= 3'b101; // move to state F
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
                3'b101: begin // state F
                    g_reg <= 0; // set g to 0
                end
            endcase
            f_reg <= 0; // reset f after one clock cycle
        end
    end

    assign f = f_reg;
    assign g = g_reg;

endmodule