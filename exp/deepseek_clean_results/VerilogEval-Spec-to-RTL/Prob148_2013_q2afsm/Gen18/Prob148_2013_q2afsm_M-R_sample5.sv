module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding
    parameter [1:0] STATE_A = 2'b00;  // No grant
    parameter [1:0] STATE_B = 2'b01;  // g0 granted
    parameter [1:0] STATE_C = 2'b10;  // g1 granted
    parameter [1:0] STATE_D = 2'b11;  // g2 granted

    reg [1:0] current_state, next_state;
    reg [2:0] g_reg;

    // Combinational next state and output logic
    always @(*) begin
        next_state = current_state;
        g_reg = 3'b000;
        
        case (current_state)
            STATE_A: begin
                if (r[0]) begin
                    next_state = STATE_B;
                    g_reg = 3'b001;
                end
                else if (r[1]) begin
                    next_state = STATE_C;
                    g_reg = 3'b010;
                end
                else if (r[2]) begin
                    next_state = STATE_D;
                    g_reg = 3'b100;
                end
            end
            STATE_B: begin
                g_reg = 3'b001;
                next_state = r[0] ? STATE_B : STATE_A;
            end
            STATE_C: begin
                g_reg = 3'b010;
                next_state = r[1] ? STATE_C : STATE_A;
            end
            STATE_D: begin
                g_reg = 3'b100;
                next_state = r[2] ? STATE_D : STATE_A;
            end
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

    assign g = g_reg;

endmodule