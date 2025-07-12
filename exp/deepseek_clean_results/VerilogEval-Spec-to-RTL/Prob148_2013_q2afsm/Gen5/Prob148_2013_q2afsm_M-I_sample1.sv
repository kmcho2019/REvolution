module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Gray-coded state encoding for minimal transitions
    localparam [1:0] STATE_A = 2'b00,
                     STATE_B = 2'b01,
                     STATE_C = 2'b11,
                     STATE_D = 2'b10;

    reg [1:0] current_state, next_state;
    reg clock_enable;

    // Clock gating logic for power savings in idle state
    always @(*) begin
        clock_enable = (current_state != STATE_A) || (|r);
    end

    // State register with synchronous reset and clock gating
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            g <= 3'b000;
        end
        else if (clock_enable) begin
            current_state <= next_state;
            // Registered outputs
            g <= {current_state == STATE_D, 
                  current_state == STATE_C, 
                  current_state == STATE_B};
        end
    end

    // State transition logic (unchanged but now with Gray codes)
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[0])        next_state = STATE_B;
                else if (r[1])   next_state = STATE_C;
                else if (r[2])   next_state = STATE_D;
                else            next_state = STATE_A;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
        endcase
    end

endmodule