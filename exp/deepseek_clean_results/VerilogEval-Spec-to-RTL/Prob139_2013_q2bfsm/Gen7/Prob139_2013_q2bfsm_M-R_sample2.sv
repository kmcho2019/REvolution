module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// One-hot state encoding
localparam S_IDLE      = 4'b0001;
localparam S_PULSE_F   = 4'b0010;
localparam S_MONITOR_X = 4'b0100;
localparam S_MONITOR_Y = 4'b1000;

reg [3:0] state, next_state;
reg [2:0] x_history;    // Shift register for x sequence
reg [1:0] y_timer;      // 2-bit counter for y monitoring
reg g_temp, g_perm;     // Temporary and permanent g values
reg f_pulse;            // f pulse generator

// Sequence detection
wire sequence_detected = (x_history == 3'b101);

// Output assignments
assign f = (state == S_PULSE_F);
assign g = g_perm ? g_temp : (state == S_MONITOR_Y);

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= S_IDLE;
        x_history <= 3'b0;
        y_timer <= 2'b0;
        g_temp <= 1'b0;
        g_perm <= 1'b0;
    end else begin
        state <= next_state;
        
        // Update x history shift register
        x_history <= {x_history[1:0], x};
        
        // y monitoring logic
        if (state == S_MONITOR_Y && !g_perm) begin
            y_timer <= y_timer + 1;
            if (y) begin
                g_temp <= 1'b1;
                g_perm <= 1'b1;
            end else if (y_timer == 2'b01) begin // After 2 cycles
                g_temp <= 1'b0;
                g_perm <= 1'b1;
            end
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        S_IDLE:      next_state = resetn ? S_PULSE_F : S_IDLE;
        S_PULSE_F:   next_state = S_MONITOR_X;
        S_MONITOR_X: next_state = sequence_detected ? S_MONITOR_Y : S_MONITOR_X;
        S_MONITOR_Y: next_state = g_perm ? S_MONITOR_Y : S_MONITOR_Y;
        default:     next_state = S_IDLE;
    endcase
end

endmodule