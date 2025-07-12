module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam INIT      = 3'b000;
localparam WAIT      = 3'b001;
localparam GOT_1     = 3'b010;
localparam GOT_10    = 3'b011;
localparam MONITOR_Y = 3'b100;
localparam G_ON      = 3'b101;
localparam G_OFF     = 3'b110;

reg [2:0] state;
reg [1:0] y_timer;

always @(posedge clk) begin
    if (!resetn) begin
        state <= INIT;
        f <= 1'b0;
        g <= 1'b0;
        y_timer <= 2'b0;
    end else begin
        case (state)
            INIT: begin
                f <= 1'b1;
                state <= WAIT;
            end
            
            WAIT: begin
                f <= 1'b0;
                if (x) state <= GOT_1;
            end
            
            GOT_1: begin
                if (!x) state <= GOT_10;
                else state <= GOT_1;
            end
            
            GOT_10: begin
                if (x) begin
                    state <= MONITOR_Y;
                    y_timer <= 2'b0;
                end else begin
                    state <= WAIT;
                end
            end
            
            MONITOR_Y: begin
                if (y) begin
                    state <= G_ON;
                end else if (y_timer == 2'b1) begin
                    state <= G_OFF;
                end else begin
                    y_timer <= y_timer + 1'b1;
                end
            end
            
            G_ON: begin
                // Permanent state until reset
                g <= 1'b1;
            end
            
            G_OFF: begin
                // Permanent state until reset
                g <= 1'b0;
            end
        endcase
    end
end

endmodule