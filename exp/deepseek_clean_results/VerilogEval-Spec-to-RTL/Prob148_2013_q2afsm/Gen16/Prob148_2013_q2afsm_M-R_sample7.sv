module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding with meaningful names
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,  // g0 active
        STATE_C = 2'b10,  // g1 active
        STATE_D = 2'b11   // g2 active
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[0]) next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else if (r[2]) next_state = STATE_D;
                else next_state = STATE_A;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Output logic
    always @(*) begin
        g = 3'b000;  // Default all grants inactive
        case (current_state)
            STATE_B: g[0] = 1'b1;
            STATE_C: g[1] = 1'b1;
            STATE_D: g[2] = 1'b1;
            default: g = 3'b000;
        endcase
    end

endmodule