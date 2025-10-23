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
    wire clk_enable = !(current_state == STATE_A && next_state == STATE_A);

    // Clock-gated state register with synchronous reset
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            g <= 3'b000;
        end
        else if (clk_enable) begin
            current_state <= next_state;
            // Registered outputs for better timing
            g <= (next_state == STATE_B) ? 3'b001 :
                 (next_state == STATE_C) ? 3'b010 :
                 (next_state == STATE_D) ? 3'b100 : 3'b000;
        end
    end

    // Optimized state transition logic with Gray coding
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[0])        next_state = STATE_B;
                else if (r[1])   next_state = STATE_C;
                else if (r[2])   next_state = STATE_D;
                else             next_state = STATE_A;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

endmodule