module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// State encoding
localparam INIT      = 2'b00;
localparam MONITOR_X = 2'b01;
localparam MONITOR_Y = 2'b10;

reg [1:0] state, next_state;

// Sequence detection shift register
reg [2:0] x_shift;
wire sequence_detected = (x_shift == 3'b101);

// Timeout counter
reg [1:0] timeout_counter;

// Output registers
reg f_reg, g_reg;

// State transition
always @(posedge clk) begin
    if (!resetn) begin
        state <= INIT;
        x_shift <= 3'b000;
        timeout_counter <= 2'b00;
    end else begin
        state <= next_state;
        
        // Shift in new x value
        x_shift <= {x_shift[1:0], x};
        
        // Timeout counter logic
        if (state == MONITOR_Y && !y && timeout_counter < 2'b10)
            timeout_counter <= timeout_counter + 1;
        else
            timeout_counter <= 2'b00;
    end
end

// Next state logic
always @(*) begin
    case (state)
        INIT:      next_state = resetn ? MONITOR_X : INIT;
        MONITOR_X: next_state = sequence_detected ? MONITOR_Y : MONITOR_X;
        MONITOR_Y: next_state = MONITOR_Y; // Stay until reset
        default:   next_state = INIT;
    endcase
end

// Output logic
always @(posedge clk) begin
    if (!resetn) begin
        f_reg <= 1'b0;
        g_reg <= 1'b0;
    end else begin
        // f output: single pulse after reset
        f_reg <= (state == INIT && next_state == MONITOR_X);
        
        // g output logic
        if (state == MONITOR_Y) begin
            if (y)
                g_reg <= 1'b1;
            else if (timeout_counter == 2'b10)
                g_reg <= 1'b0;
        end
    end
end

assign f = f_reg;
assign g = g_reg;

endmodule