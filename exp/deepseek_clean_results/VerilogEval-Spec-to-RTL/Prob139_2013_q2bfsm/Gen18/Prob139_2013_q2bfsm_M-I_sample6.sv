module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;
reg [2:0] x_shift;
reg [1:0] y_timer;
reg g_permanent;

localparam RESET      = 3'b000;
localparam F_PULSE    = 3'b001;
localparam WAIT_X     = 3'b010;
localparam CHECK_X    = 3'b011;
localparam MONITOR_Y  = 3'b100;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b0;
        y_timer <= 2'b0;
        g_permanent <= 1'b0;
    end else begin
        case (state)
            RESET: begin
                state <= F_PULSE;
                f <= 1'b0;
                g <= 1'b0;
            end
            
            F_PULSE: begin
                state <= WAIT_X;
                f <= 1'b1;
            end
            
            WAIT_X: begin
                f <= 1'b0;
                x_shift <= {x_shift[1:0], x};
                if (x_shift[2]) begin  // Wait until we have 3 samples
                    state <= CHECK_X;
                end
            end
            
            CHECK_X: begin
                if (x_shift == 3'b101) begin
                    state <= MONITOR_Y;
                    g <= 1'b1;
                    y_timer <= 2'b0;
                end else begin
                    state <= WAIT_X;
                end
                x_shift <= 3'b0;
            end
            
            MONITOR_Y: begin
                if (y) begin
                    g_permanent <= 1'b1;
                end else if (y_timer < 2) begin
                    y_timer <= y_timer + 1;
                end else if (!g_permanent) begin
                    g <= 1'b0;
                    g_permanent <= 1'b1;
                end
            end
        endcase
    end
end

endmodule