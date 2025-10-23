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
localparam STATE_C = 3'd2;  // First x=1 detection
localparam STATE_D = 3'd3;  // x=0 detection
localparam STATE_E = 3'd4;  // Second x=1 detection
localparam STATE_F = 3'd5;  // y monitoring state
localparam STATE_G = 3'd6;  // Final permanent state

reg [2:0] state, next_state;
reg [1:0] timeout_counter;

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        timeout_counter <= 0;
    end
    else begin
        state <= next_state;
        
        // Output assignments
        case (next_state)
            STATE_B: f <= 1;
            default: f <= 0;
        endcase
        
        // g assignment logic
        if (next_state == STATE_E && x) g <= 1;
        else if (next_state == STATE_G && timeout_counter == 2'd1 && !y) g <= 0;
        
        // Timeout counter logic
        if (state == STATE_E && next_state == STATE_F) begin
            timeout_counter <= 0;
        end
        else if (state == STATE_F && next_state == STATE_F) begin
            timeout_counter <= timeout_counter + 1;
        end
    end
end

always @(*) begin
    // Default next state
    next_state = state;
    
    case (state)
        STATE_A: begin
            if (resetn) next_state = STATE_B;
        end
        
        STATE_B: begin
            next_state = STATE_C;
        end
        
        STATE_C: begin
            if (x) next_state = STATE_D;
        end
        
        STATE_D: begin
            if (!x) next_state = STATE_E;
            else next_state = STATE_C;
        end
        
        STATE_E: begin
            if (x) next_state = STATE_F;
            else next_state = STATE_C;
        end
        
        STATE_F: begin
            if (y) next_state = STATE_G;
            else if (timeout_counter == 2'd1) next_state = STATE_G;
        end
        
        STATE_G: begin
            // Permanent state - no transitions
        end
    endcase
end

endmodule