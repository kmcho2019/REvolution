module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States
localparam IDLE     = 2'b00;
localparam F_PULSE  = 2'b01;
localparam MONITOR  = 2'b10;

reg [1:0] state, next_state;
reg [2:0] x_shift;  // Shift register for x pattern
reg [1:0] y_timer;  // 2-cycle timer for y monitoring

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        x_shift <= 3'b0;
        y_timer <= 2'b0;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        if (state == MONITOR && g && !y) begin
            y_timer <= y_timer + 1;
        end else begin
            y_timer <= 2'b0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE:    next_state = resetn ? F_PULSE : IDLE;
        F_PULSE: next_state = MONITOR;
        MONITOR: next_state = MONITOR;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f <= 0;
        g <= 0;
    end else begin
        // f output (one cycle pulse)
        f <= (state == IDLE && resetn);
        
        // g output logic
        if (state == MONITOR) begin
            if (x_shift == 3'b101) begin
                g <= 1;
            end else if (g && y_timer == 2'b10) begin
                g <= 0;
            end
        end else begin
            g <= 0;
        end
    end
end

endmodule