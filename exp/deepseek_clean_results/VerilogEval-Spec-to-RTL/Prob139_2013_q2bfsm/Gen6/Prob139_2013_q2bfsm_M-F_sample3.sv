module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 3'd0;  // Reset state
localparam STATE_B = 3'd1;  // f=1 pulse state
localparam STATE_C = 3'd2;  // Waiting for first x=1
localparam STATE_D = 3'd3;  // Waiting for x=0 after first x=1
localparam STATE_E = 3'd4;  // Waiting for second x=1 (will set g=1)
localparam STATE_F = 3'd5;  // Monitoring y with timeout
localparam STATE_G = 3'd6;  // Final permanent state (g=1)
localparam STATE_H = 3'd7;  // Final permanent state (g=0)

reg [2:0] state, next_state;
reg [1:0] timeout_counter;
reg resetn_prev;

always @(posedge clk) begin
    resetn_prev <= resetn;
end

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        timeout_counter <= 0;
    end
    else begin
        state <= next_state;
        f <= 0;  // Default f=0 except in STATE_B
        
        case (state)
            STATE_A: begin
                if (resetn && !resetn_prev) begin
                    f <= 1;
                    next_state <= STATE_B;
                end
            end
            
            STATE_B: begin
                next_state <= STATE_C;
            end
            
            STATE_C: begin
                if (x) next_state <= STATE_D;
                // Stay in STATE_C until first x=1
            end
            
            STATE_D: begin
                if (!x) next_state <= STATE_E;
                else if (x) next_state <= STATE_D;  // Stay if still x=1
                // else stay in STATE_D (waiting for x=0)
            end
            
            STATE_E: begin
                if (x) begin
                    g <= 1;
                    next_state <= STATE_F;
                    timeout_counter <= 0;
                end
                else next_state <= STATE_C;  // Reset sequence if x=0
            end
            
            STATE_F: begin
                if (y) begin
                    next_state <= STATE_G;  // Permanent g=1
                end
                else if (timeout_counter == 2'd1) begin
                    g <= 0;
                    next_state <= STATE_H;  // Permanent g=0
                end
                else begin
                    timeout_counter <= timeout_counter + 1;
                end
            end
            
            STATE_G, STATE_H: begin
                // Permanent states - no changes
            end
        endcase
    end
end

// Default next_state to prevent latches
always @(*) begin
    next_state = state;
end

endmodule