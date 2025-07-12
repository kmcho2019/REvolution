module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

reg [1:0] state;
reg [1:0] nextState;
reg [1:0] x_counter;
reg [1:0] y_counter;
reg f_reg;
reg g_reg;

initial begin
    state = 2'b00; // state A
    x_counter = 2'b00;
    y_counter = 2'b00;
    f_reg = 0;
    g_reg = 0;
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // state A
        x_counter <= 2'b00;
        y_counter <= 2'b00;
        f_reg <= 0;
        g_reg <= 0;
    end else begin
        case (state)
            2'b00: begin // state A
                if (~resetn) begin
                    state <= 2'b00;
                end else begin
                    state <= 2'b01; // state B
                    f_reg <= 1;
                end
            end
            2'b01: begin // state B
                f_reg <= 0;
                state <= 2'b10; // state C
            end
            2'b10: begin // state C
                if (x) begin
                    x_counter <= x_counter + 1;
                end else begin
                    x_counter <= 0;
                end
                if (x_counter == 3'b101) begin // 1, 0, 1
                    state <= 2'b11; // state D
                    g_reg <= 1;
                    x_counter <= 0;
                end else begin
                    state <= 2'b10; // state C
                end
            end
            2'b11: begin // state D
                if (~y) begin
                    y_counter <= y_counter + 1;
                end else begin
                    y_counter <= 0;
                    state <= 2'b11; // state D
                end
                if (y_counter == 2) begin
                    g_reg <= 0;
                    state <= 2'b10; // state C
                    y_counter <= 0;
                end else begin
                    state <= 2'b11; // state D
                end
            end
        endcase
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule