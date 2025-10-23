module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

parameter IDLE = 2'b00;
parameter SET_F = 2'b01;
parameter MONITOR_X = 2'b10;
parameter MONITOR_Y = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

reg [1:0] x_counter;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        f <= 0;
        g <= 0;
        x_counter <= 0;
        y_timer <= 0;
    end else begin
        state <= next_state;
        case (state)
            SET_F: begin
                f <= 1;
                g <= 0;
            end
            MONITOR_Y: begin
                g <= 1;
                if (y) begin
                    y_timer <= 0;
                end else if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
        if (state == MONITOR_X) begin
            if (x) begin
                x_counter <= x_counter + 1;
            end else begin
                x_counter <= 0;
            end
        end else begin
            x_counter <= 0;
        end
    end
end

always @(*) begin
    case (state)
        IDLE: next_state = (resetn)? SET_F : IDLE;
        SET_F: next_state = MONITOR_X;
        MONITOR_X: next_state = (x_counter == 3)? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = (y_timer == 2)? IDLE : MONITOR_Y;
    endcase
end

endmodule