module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam RESET      = 2'b00;
localparam PULSE_F    = 2'b01;
localparam OPERATIONAL = 2'b10;
localparam LOCKED     = 2'b11;

reg [1:0] state, next_state;
reg [2:0] x_shift;
reg [1:0] y_timer;
reg sequence_detected;
reg g_locked;
reg g_value;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= RESET;
        x_shift <= 3'b000;
        y_timer <= 0;
        sequence_detected <= 0;
        g_locked <= 0;
    end else begin
        state <= next_state;
        x_shift <= {x_shift[1:0], x};
        
        if (state == OPERATIONAL && !g_locked) begin
            if (sequence_detected) begin
                y_timer <= y_timer + 1;
                if (y) begin
                    g_value <= 1;
                    g_locked <= 1;
                end else if (y_timer == 1) begin
                    g_value <= 0;
                    g_locked <= 1;
                end
            end
            else if (x_shift == 3'b101) begin
                sequence_detected <= 1;
                g_value <= 1;
                y_timer <= 0;
            end
        end
    end
end

// Next state logic
always @(*) begin
    case (state)
        RESET: next_state = resetn ? PULSE_F : RESET;
        PULSE_F: next_state = OPERATIONAL;
        OPERATIONAL: next_state = g_locked ? LOCKED : OPERATIONAL;
        LOCKED: next_state = LOCKED;
        default: next_state = RESET;
    endcase
end

// Output logic
assign f = (state == PULSE_F);
assign g = (state == LOCKED) ? g_value : 
           (state == OPERATIONAL && sequence_detected && !g_locked);

endmodule