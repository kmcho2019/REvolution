module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // Simplified state encoding
    localparam [1:0] STATE_A = 2'b00,
                     STATE_B = 2'b01,
                     STATE_C = 2'b10;

    reg [1:0] current_state, next_state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Simplified state transition logic
    always @(*) begin
        case (current_state)
            STATE_A: begin
                if (r[0])      next_state = STATE_B;
                else if (r[1]) next_state = STATE_C;
                else           next_state = STATE_A;
            end
            STATE_B: next_state = r[0] ? STATE_B : STATE_A;
            STATE_C: next_state = r[1] ? STATE_C : STATE_A;
        endcase
    end

    // Output logic - simplified to only needed outputs
    assign g = (current_state == STATE_B) ? 3'b001 : 
               (current_state == STATE_C) ? 3'b010 : 
               3'b000;

endmodule