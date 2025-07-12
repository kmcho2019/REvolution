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
localparam STATE_F = 3'd5;  // y monitoring state (2-cycle timeout)
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
        
        // Output f is only high in STATE_B
        f <= (next_state == STATE_B);
        
        // Output g control
        case (next_state)
            STATE_E: g <= (x == 1'b1);  // Set g when sequence completes
            STATE_F: g <= 1'b1;         // Maintain g while monitoring y
            STATE_G: g <= (timeout_counter != 2'd1 || y); // Permanent state
            default: g <= 1'b0;
        endcase
        
        // Timeout counter control
        if (next_state == STATE_F) begin
            timeout_counter <= (state == STATE_F) ? timeout_counter + 1 : 0;
        end
        else begin
            timeout_counter <= 0;
        end
    end
end

always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        
        STATE_B: next_state = STATE_C;
        
        STATE_C: next_state = x ? STATE_D : STATE_C;
        
        STATE_D: begin
            if (x) next_state = STATE_C;  // Sequence broken
            else next_state = STATE_E;    // x=0 detected
        end
        
        STATE_E: next_state = x ? STATE_F : STATE_C;
        
        STATE_F: begin
            if (y) next_state = STATE_G;  // y detected
            else if (timeout_counter == 2'd1) 
                next_state = STATE_G;      // Timeout after 2 cycles
            else 
                next_state = STATE_F;     // Continue monitoring
        end
        
        STATE_G: next_state = STATE_G;    // Permanent state
        
        default: next_state = STATE_A;
    endcase
end

endmodule