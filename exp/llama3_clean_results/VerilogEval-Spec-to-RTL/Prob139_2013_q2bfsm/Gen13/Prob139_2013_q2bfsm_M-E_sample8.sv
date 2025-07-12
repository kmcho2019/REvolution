module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States for reset controller
parameter RESET_IDLE = 2'b00, RESET_PULSE_F = 2'b01;

// States for x sequence detector
parameter X_IDLE = 2'b00, X_1 = 2'b01, X_0 = 2'b10, X_1_AGAIN = 2'b11;

// States for g controller
parameter G_IDLE = 2'b00, G_WAIT_Y = 2'b01, G_SET = 2'b10, G_CLEAR = 2'b11;

// Current states
reg [1:0] reset_state;
reg [1:0] x_state;
reg [1:0] g_state;

// Output signals
reg f_out;
reg g_out;

// Reset controller
always @ (posedge clk) begin
    if (!resetn) begin
        reset_state <= RESET_IDLE;
        f_out <= 0;
    end else begin
        case (reset_state)
            RESET_IDLE: begin
                reset_state <= RESET_PULSE_F;
                f_out <= 1;
            end
            RESET_PULSE_F: begin
                reset_state <= RESET_IDLE;
                f_out <= 0;
            end
        endcase
    end
end

// X sequence detector
always @ (posedge clk) begin
    if (!resetn) begin
        x_state <= X_IDLE;
    end else begin
        case (x_state)
            X_IDLE: begin
                if (x) begin
                    x_state <= X_1;
                end
            end
            X_1: begin
                if (!x) begin
                    x_state <= X_0;
                end else begin
                    x_state <= X_1;
                end
            end
            X_0: begin
                if (x) begin
                    x_state <= X_1_AGAIN;
                end else begin
                    x_state <= X_0;
                end
            end
            X_1_AGAIN: begin
                x_state <= X_IDLE;
            end
        endcase
    end
end

// G controller
always @ (posedge clk) begin
    if (!resetn) begin
        g_state <= G_IDLE;
        g_out <= 0;
    end else begin
        case (g_state)
            G_IDLE: begin
                if (x_state == X_1_AGAIN) begin
                    g_state <= G_WAIT_Y;
                end
            end
            G_WAIT_Y: begin
                if (y) begin
                    g_state <= G_SET;
                    g_out <= 1;
                end else begin
                    g_state <= G_WAIT_Y;
                end
            end
            G_SET: begin
                g_out <= 1;
            end
            G_CLEAR: begin
                g_out <= 0;
            end
        endcase
    end
end

assign f = f_out;
assign g = g_out;

endmodule