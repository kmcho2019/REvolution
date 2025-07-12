`define SET_F 0
`define WAIT_X 1
`define CHECK_Y 2
`define G_ON 3
`define G_OFF 4

module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [1:0] x_counter;
reg [1:0] y_counter;
reg seen_y;

always @(posedge clk) begin
    if (~resetn) begin
        state <= `SET_F;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_counter <= 0;
        seen_y <= 0;
    end else begin
        case(state)
            `SET_F: begin
                f <= 1;
                state <= `WAIT_X;
            end
            `WAIT_X: begin
                f <= 0;
                case(x_counter)
                    0: begin
                        if (x) x_counter <= 1;
                    end
                    1: begin
                        if (~x) x_counter <= 2;
                        else x_counter <= 1;
                    end
                    2: begin
                        if (x) begin
                            x_counter <= 0;
                            state <= `CHECK_Y;
                            g <= 1;
                            y_counter <= 0;
                            seen_y <= 0;
                        end else x_counter <= 2;
                    end
                endcase
            end
            `CHECK_Y: begin
                if (y) begin
                    seen_y <= 1;
                    state <= `G_ON;
                end else if (y_counter == 2) begin
                    state <= `G_OFF;
                end else begin
                    y_counter <= y_counter + 1;
                end
            end
            `G_ON: begin
                g <= 1;
            end
            `G_OFF: begin
                g <= 0;
            end
        endcase
    end
end

endmodule