`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Enum for states
typedef enum logic [2:0] {
    STATE_A = 3'b000, // Reset state
    SET_F   = 3'b001, // Set f to 1
    MONITOR_X1 = 3'b010, // Monitor x for sequence 1, 0, 1 (1)
    MONITOR_X2 = 3'b011, // Monitor x for sequence 1, 0, 1 (0)
    MONITOR_X3 = 3'b100, // Monitor x for sequence 1, 0, 1 (1)
    SET_G   = 3'b101, // Set g to 1
    MONITOR_Y1 = 3'b110, // Monitor y (1st cycle)
    MONITOR_Y2 = 3'b111, // Monitor y (2nd cycle)
    G_HIGH  = 3'b1000, // g remains high
    G_LOW   = 3'b1001  // g remains low
} state_t;

// State register
state_t current_state, next_state;

// Output registers
logic f_out, g_out;

// Sequential logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        current_state <= STATE_A;
        f_out <= 0;
        g_out <= 0;
    end else begin
        current_state <= next_state;
        f_out <= (current_state == SET_F) ? 1'b1 : 1'b0;
        g_out <= (current_state == SET_G || current_state == G_HIGH) ? 1'b1 : (current_state == G_LOW) ? 1'b0 : g_out;
    end
end

// Combinational logic
always @(*) begin
    next_state = current_state; // Default: Stay in current state
    
    case (current_state)
        STATE_A: if (resetn) next_state = SET_F;
        SET_F: next_state = MONITOR_X1;
        
        MONITOR_X1: if (x) next_state = MONITOR_X2;
                   else next_state = MONITOR_X1;
        MONITOR_X2: if (~x) next_state = MONITOR_X3;
                   else next_state = MONITOR_X1;
        MONITOR_X3: if (x) next_state = SET_G;
                   else next_state = MONITOR_X1;
        
        SET_G: next_state = MONITOR_Y1;
        
        MONITOR_Y1: if (y) next_state = G_HIGH;
                   else next_state = MONITOR_Y2;
        MONITOR_Y2: if (y) next_state = G_HIGH;
                   else next_state = G_LOW;
        
        G_HIGH, G_LOW: ; // Stay in these states
    endcase
end

assign f = f_out;
assign g = g_out;

endmodule