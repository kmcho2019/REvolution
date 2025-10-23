module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding (only 2 bits needed for 4 states)
    parameter [1:0] STATE_A = 2'b00;  // No grant
    parameter [1:0] STATE_B = 2'b01;  // g0 granted
    parameter [1:0] STATE_C = 2'b10;  // g1 granted
    parameter [1:0] STATE_D = 2'b11;  // g2 granted

    reg [1:0] current_state, next_state;

    // Combinational next state logic with casez for priority
    always @(*) begin
        case (current_state)
            STATE_A: begin
                casez (r)
                    3'b1??: next_state = STATE_B;  // r[0] has priority
                    3'b01?: next_state = STATE_C;   // then r[1]
                    3'b001: next_state = STATE_D;   // then r[2]
                    default: next_state = STATE_A;
                endcase
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Sequential state flip-flops
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Optimal output decoding - purely combinational from state
    assign g = (current_state == STATE_B) ? 3'b001 :
               (current_state == STATE_C) ? 3'b010 :
               (current_state == STATE_D) ? 3'b100 : 3'b000;

endmodule