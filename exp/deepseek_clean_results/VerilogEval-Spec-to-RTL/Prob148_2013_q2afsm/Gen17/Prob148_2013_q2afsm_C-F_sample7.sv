module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Binary state encoding (2 bits)
    parameter [1:0] STATE_A = 2'b00;  // Idle
    parameter [1:0] STATE_B = 2'b01;  // g0 granted
    parameter [1:0] STATE_C = 2'b10;  // g1 granted
    parameter [1:0] STATE_D = 2'b11;  // g2 granted

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                // Priority encoder for new grants
                if (r[0])       next_state = STATE_B;
                else if (r[1])  next_state = STATE_C;
                else if (r[2])  next_state = STATE_D;
                else            next_state = STATE_A;
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

    // Output assignments - decode only active grant
    assign g[0] = (current_state == STATE_B);
    assign g[1] = (current_state == STATE_C);
    assign g[2] = (current_state == STATE_D);

endmodule