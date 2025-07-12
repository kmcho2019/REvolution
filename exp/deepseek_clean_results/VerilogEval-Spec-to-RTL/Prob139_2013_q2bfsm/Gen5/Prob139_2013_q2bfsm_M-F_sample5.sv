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
localparam STATE_G = 3'd6;  // Final permanent state

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
        
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                if (resetn && !resetn_prev) begin
                    f <= 1;  // Immediate pulse when reset is deasserted
                    next_state <= STATE_B;
                end
            end
            
            STATE_B: begin
                next_state <= STATE_C;
            end
            
            STATE_C: begin
                if (x) next_state <= STATE_D;  // First x=1 detected
                else next_state <= STATE_C;
            end
            
            STATE_D: begin
                if (!x) next_state <= STATE_E;  // x=0 detected
                else next_state <= STATE_C;     // x=1 again - reset sequence
            end
            
            STATE_E: begin
                if (x) begin                   // Second x=1 completes sequence
                    g <= 1;
                    next_state <= STATE_F;
                    timeout_counter <= 0;
                end
                else next_state <= STATE_C;    // x=0 again - reset sequence
            end
            
            STATE_F: begin
                if (y) begin
                    next_state <= STATE_G;     // y=1 detected
                end
                else if (timeout_counter == 2'd1) begin
                    g <= 0;                   // Timeout reached
                    next_state <= STATE_G;
                end
                timeout_counter <= timeout_counter + 1;
            end
            
            STATE_G: begin
                // Permanent state - no changes
            end
        endcase
    end
end

endmodule