module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Binary state encoding (2 bits)
    parameter [1:0] STATE_A = 2'b00;
    parameter [1:0] STATE_B = 2'b01;
    parameter [1:0] STATE_C = 2'b10;
    parameter [1:0] STATE_D = 2'b11;

    reg [1:0] current_state, next_state;
    reg [2:0] g_next;

    // Combinational next state logic with parallel case structure
    always @(*) begin
        case (current_state)
            STATE_A: begin
                casez (r)
                    3'b1??: next_state = STATE_B;  // Priority to r[0]
                    3'b01?: next_state = STATE_C;  // Then r[1]
                    3'b001: next_state = STATE_D;  // Finally r[2]
                    default: next_state = STATE_A;
                endcase
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
            STATE_D: next_state = r[2] ? STATE_D : STATE_A;
            default: next_state = STATE_A;
        endcase
    end

    // Output generation - registered for better timing
    always @(*) begin
        case (current_state)
            STATE_B: g_next = 3'b001;
            STATE_C: g_next = 3'b010;
            STATE_D: g_next = 3'b100;
            default: g_next = 3'b000;
        endcase
    end

    // Sequential logic (state and outputs)
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
            g <= 3'b000;
        end else begin
            current_state <= next_state;
            g <= g_next;
        end
    end

endmodule