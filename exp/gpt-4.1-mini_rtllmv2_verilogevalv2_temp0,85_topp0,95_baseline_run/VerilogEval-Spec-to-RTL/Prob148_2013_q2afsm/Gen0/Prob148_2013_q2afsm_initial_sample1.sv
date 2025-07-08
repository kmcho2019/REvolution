module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0]
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11;

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (r[0])
                    next_state = STATE_B;
                else if (r[1])
                    next_state = STATE_C;
                else if (r[2])
                    next_state = STATE_D;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                if (r[0])
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_C: begin
                if (r[1])
                    next_state = STATE_C;
                else
                    next_state = STATE_A;
            end

            STATE_D: begin
                if (r[2])
                    next_state = STATE_D;
                else
                    next_state = STATE_A;
            end

            default: next_state = STATE_A;
        endcase
    end

    // Output logic: grant signals
    // g[0] = 1 for STATE_B, g[1] = 1 for STATE_C, g[2] = 1 for STATE_D
    assign g = (state == STATE_B) ? 3'b001 :
               (state == STATE_C) ? 3'b010 :
               (state == STATE_D) ? 3'b100 :
               3'b000;

endmodule