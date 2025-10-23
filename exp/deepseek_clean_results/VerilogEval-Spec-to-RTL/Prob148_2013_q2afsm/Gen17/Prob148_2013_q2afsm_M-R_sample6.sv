module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding
    parameter [1:0] STATE_A = 2'b00;
    parameter [1:0] STATE_B = 2'b01;
    parameter [1:0] STATE_C = 2'b10;
    parameter [1:0] STATE_D = 2'b11;

    reg [1:0] current_state, next_state;
    reg [2:0] g_reg;

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational next state logic
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
        g_reg = 3'b000;
        case (current_state)
            STATE_B: g_reg = 3'b001;
            STATE_C: g_reg = 3'b010;
            STATE_D: g_reg = 3'b100;
            default: g_reg = 3'b000;
        endcase
    end

    assign g = g_reg;

endmodule