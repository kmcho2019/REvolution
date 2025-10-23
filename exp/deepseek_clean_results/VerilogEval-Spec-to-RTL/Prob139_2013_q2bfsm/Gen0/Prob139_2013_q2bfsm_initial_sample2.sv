module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D,
    STATE_E,
    STATE_F
} state_t;

reg [2:0] state, next_state;

// State transition and output logic
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
    end
    else begin
        state <= next_state;
        
        // Output logic
        case (next_state)
            STATE_A: begin
                f <= 0;
                g <= 0;
            end
            STATE_B: begin
                f <= 1;  // Pulse f for one cycle
                g <= 0;
            end
            STATE_C, STATE_D: begin
                f <= 0;
                g <= 0;
            end
            STATE_E: begin
                f <= 0;
                g <= 1;  // Set g when sequence detected
            end
            STATE_F: begin
                f <= 0;
                // g maintains its value permanently
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    case (state)
        STATE_A: next_state = resetn ? STATE_B : STATE_A;
        
        STATE_B: next_state = STATE_C;
        
        STATE_C: begin
            if (x == 1)
                next_state = STATE_D;
            else
                next_state = STATE_C;
        end
        
        STATE_D: begin
            if (x == 1)
                next_state = STATE_E;
            else
                next_state = STATE_C;
        end
        
        STATE_E: begin
            if (y == 1)
                next_state = STATE_F;
            else
                // Stay in E for max 2 cycles
                next_state = STATE_E;  // Will be handled by counter
        end
        
        STATE_F: next_state = STATE_F;
        
        default: next_state = STATE_A;
    endcase
end

// Counter for STATE_E timeout (2 cycles)
reg [1:0] timeout_counter;
always @(posedge clk) begin
    if (!resetn) begin
        timeout_counter <= 0;
    end
    else begin
        if (state == STATE_E) begin
            if (y == 1) begin
                timeout_counter <= 0;
            end
            else if (timeout_counter < 2) begin
                timeout_counter <= timeout_counter + 1;
            end
            else begin
                // Timeout reached, set g=0 permanently
                g <= 0;
                next_state <= STATE_F;
            end
        end
        else begin
            timeout_counter <= 0;
        end
    end
end

endmodule