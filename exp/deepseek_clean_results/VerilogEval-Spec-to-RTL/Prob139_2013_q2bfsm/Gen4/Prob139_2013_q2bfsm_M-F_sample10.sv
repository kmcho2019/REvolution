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

reg [2:0] state;
reg [1:0] timeout_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        timeout_counter <= 0;
    end
    else begin
        // Default outputs
        f <= 0;
        
        case (state)
            STATE_A: begin
                // Stay in reset state until resetn is deasserted
                if (resetn) state <= STATE_B;
            end
            
            STATE_B: begin
                f <= 1;  // Pulse f for one cycle
                state <= STATE_C;
            end
            
            STATE_C: begin
                if (x) state <= STATE_D;  // First x=1 detected
                // Otherwise stay in STATE_C
            end
            
            STATE_D: begin
                if (!x) state <= STATE_E;  // x=0 detected after x=1
                else state <= STATE_C;    // x=1 again - reset sequence
            end
            
            STATE_E: begin
                if (x) begin              // Second x=1 completes 1-0-1 sequence
                    g <= 1;
                    state <= STATE_F;
                    timeout_counter <= 0;  // Initialize timeout counter
                end
                else state <= STATE_C;     // x=0 again - reset sequence
            end
            
            STATE_F: begin
                if (y) begin
                    state <= STATE_G;      // y=1 detected within timeout
                end
                else if (timeout_counter == 2'd1) begin
                    g <= 0;               // Timeout reached without y=1
                    state <= STATE_G;
                end
                else begin
                    timeout_counter <= timeout_counter + 1;  // Increment timeout
                end
            end
            
            STATE_G: begin
                // Permanent state - maintain current g value
                // No state transitions needed
            end
        endcase
    end
end

endmodule